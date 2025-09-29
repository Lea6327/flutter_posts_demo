

// Shows the posts list with proper loading, error (with Retry), and success states.
// Uses flutter_bloc (Cubit) for state management, Material 3 theming,
// pull-to-refresh, a debug-only "simulate error" toggle, and a simple skeleton
// loading list for nicer UX.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../../domain/entities/post_entity.dart';
import '../cubit/posts_cubit.dart';
import '../widgets/error_view.dart';
import '../pages/post_detail_page.dart';
import '../../data/sources/posts_api.dart'; // For the debug error toggle

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    super.initState();
    // First-load fetch (make sure you DON'T also call ..fetch() in BlocProvider)
    context.read<PostsCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          // Debug-only action to toggle the fake error switch at runtime.
          // Handy for demonstrating "error -> Retry -> loading -> success".
          if (kDebugMode)
            IconButton(
              tooltip: PostsApi.kUseBadPath ? 'Error mode: ON' : 'Error mode: OFF',
              icon: Icon(
                PostsApi.kUseBadPath ? Icons.bug_report : Icons.bug_report_outlined,
              ),
              onPressed: () {
                // Flip the error simulation switch and refetch immediately.
                PostsApi.kUseBadPath = !PostsApi.kUseBadPath;
                context.read<PostsCubit>().fetch();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      PostsApi.kUseBadPath
                          ? 'Error ON (Retry view will appear)'
                          : 'Error OFF',
                    ),
                  ),
                );
              },
            ),
        ],
      ),

      // BlocBuilder wires the UI to PostsCubit state.
      body: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          // Initial & loading -> skeleton list (nicer than a spinner wall)
          if (state is PostsInitial || state is PostsLoading) {
            return const _SkeletonList();
          }

          // Error -> friendly message + Retry button
          if (state is PostsError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<PostsCubit>().fetch(),
            );
          }

          // Success -> list + pull-to-refresh
          if (state is PostsLoaded) {
            final List<PostEntity> posts = state.posts;
            if (posts.isEmpty) return const _EmptyView();

            // IMPORTANT:
            // Use a single scrollable root (ListView) + AlwaysScrollable
            // so pull-to-refresh works even if items < 1 screen.
            return RefreshIndicator(
              onRefresh: () => context.read<PostsCubit>().fetch(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) => _PostCard(post: posts[i]),
              ),
            );
          }

          // Defensive: always return a widget
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// ---------------- List item (card) ----------------

class _PostCard extends StatelessWidget {
  final PostEntity post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1.5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        // Navigate to the new, polished detail page
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailPage(post: post)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero matches the tag in the detail page for a smooth transition
              Hero(
                tag: 'post-title-${post.id}',
                child: Text(
                  post.title,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                post.body,
                style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- Skeleton loading list ----------------

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: 8, // number of skeleton rows
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surfaceVariant.withOpacity(0.6),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _SkeletonLine(widthFactor: 1.0, height: 18),
              SizedBox(height: 10),
              _SkeletonLine(widthFactor: 1.0, height: 12),
              SizedBox(height: 8),
              _SkeletonLine(widthFactor: 0.6, height: 12),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double widthFactor;
  final double height;
  const _SkeletonLine({required this.widthFactor, required this.height});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: cs.outlineVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// ---------------- Empty state ----------------

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('No posts yet. Pull to refresh.'),
      ),
    );
  }
}










