import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';

class PostTile extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onTap;
  const PostTile({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text(
        post.body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}


