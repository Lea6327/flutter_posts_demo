import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';            
import '../../domain/entities/post_entity.dart';

class PostDetailPage extends StatelessWidget {
  final PostEntity post;
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: const BackButton(),
            pinned: true,
            stretch: true,
            backgroundColor: cs.surface,
            title: Text('Post #${post.id}'),
            actions: [
              IconButton(                                // share button
                tooltip: 'Share',
                icon: const Icon(Icons.share),
                onPressed: () {
                  final text = '${post.title}\n\n${post.body}\n\n(Post #${post.id})';
                  Share.share(text, subject: 'Post #${post.id}');
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'post-title-${post.id}',
                            child: Text(
                              post.title,
                              style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            post.body,
                            style: t.bodyLarge?.copyWith(height: 1.5, color: cs.onSurface.withOpacity(0.9)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _MetaChip(icon: Icons.badge, label: 'ID'), // label 
                      _MetaChip(icon: Icons.person, label: 'User'),
                    ].map((chip) => chip.withValue(post)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? value; //  ID/User
  const _MetaChip({required this.icon, required this.label, this.value});

  _MetaChip withValue(PostEntity post) => label == 'ID'
      ? _MetaChip(icon: icon, label: 'ID ${post.id}')
      : _MetaChip(icon: icon, label: 'User ${post.userId}');

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(icon, size: 16, color: cs.onSurfaceVariant),
      label: Text(label),
      backgroundColor: cs.surfaceVariant,
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}






