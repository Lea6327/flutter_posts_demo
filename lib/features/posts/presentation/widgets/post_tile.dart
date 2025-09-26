import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';

class PostTile extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onTap;

  const PostTile({
    super.key,
    required this.post,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final preview = post.body.trim().replaceAll('\n', ' ');
    final previewText =
        preview.length > 120 ? '${preview.substring(0, 120)}…' : preview;

    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          post.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            previewText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.35,
                ),
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
      ),
    );
  }
}



