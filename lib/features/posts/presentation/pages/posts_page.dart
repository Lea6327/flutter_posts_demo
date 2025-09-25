import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/posts_cubit.dart';
import '../cubit/posts_state.dart';
import '../widgets/post_tile.dart';
import 'post_detail_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    super.initState();
    // Trigger initial load when entering the page
    context.read<PostsCubit>().load();
  }

  Future<void> _refresh() async {
    // Pull-to-refresh reloads posts
    await context.read<PostsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          // Loading state: spinner + text (centered)
          if (state.loading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading posts...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // Error state: icon + message + Retry button
          if (state.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 36),
                    const SizedBox(height: 12),
                    Text(
                      state.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.read<PostsCubit>().load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Success state: list view (supports pull-to-refresh)
          final posts = state.posts;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: posts.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, i) {
                final p = posts[i];
                return PostTile(
                  post: p,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(post: p),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}



