import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';

class PostDetailPage extends StatelessWidget {
  final PostEntity post;
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
            const Divider(height: 32),
            Text('ID: ${post.id} • User: ${post.userId}',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}



