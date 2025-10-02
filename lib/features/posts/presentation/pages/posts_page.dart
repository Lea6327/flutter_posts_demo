import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/sources/posts_api.dart' as api; 
import '../../domain/entities/post_entity.dart';
import '../cubit/posts_cubit.dart';
import '../pages/post_detail_page.dart';
import '../widgets/error_view.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostsCubit>().fetch(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          // Debug-only: toggle simulated error and refetch
          if (kDebugMode)
            IconButton(
              tooltip: api.PostsApi.kUseBadPath ? 'Error mode: ON' : 'Error mode: OFF',
              icon: Icon(
                api.PostsApi.kUseBadPath ? Icons.bug_report : Icons.bug_report_outlined,
              ),
              onPressed: () {
                api.PostsApi.kUseBadPath = !api.PostsApi.kUseBadPath;
                context.read<PostsCubit>().fetch(refresh: true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      api.PostsApi.kUseBadPath
                          ? 'Simulating failures…'
                          : 'Error mode off. Fetching…',
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          if (state is PostsInitial || state is PostsLoading) {
            return const _SkeletonList();
          }

          
          // if error mode is ON, turn it OFF first, then fetch.
          if (state is PostsError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                if (kDebugMode && api.PostsApi.kUseBadPath) {
                  api.PostsApi.kUseBadPath = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error mode off. Retrying…')),
                  );
                }
                context.read<PostsCubit>().fetch(refresh: true);
              },
            );
          }

          if (state is PostsLoaded) {
            final posts = state.posts;
            if (posts.isEmpty) return const _EmptyView();

            return RefreshIndicator(
              onRefresh: () => context.read<PostsCubit>().fetch(refresh: true),
              child: NotificationListener<ScrollNotification>(
                onNotification: (sn) {
                  if (state.hasMore &&
                      sn.metrics.pixels >= sn.metrics.maxScrollExtent - 200) {
                    context.read<PostsCubit>().fetch();
                  }
                  return false;
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: posts.length + (state.hasMore ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    if (i >= posts.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return _PostCard(post: posts[i]);
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// Card for each post
class _PostCard extends StatelessWidget {
  final PostEntity post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      elevation: 1.5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailPage(post: post)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'post-title-${post.id}',
                child: Text(
                  post.title,
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                post.body,
                style: t.bodyMedium?.copyWith(color: Colors.black87),
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

/// Skeleton list for loading
class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(16),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
          color: cs.outlineVariant.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Empty view
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

















