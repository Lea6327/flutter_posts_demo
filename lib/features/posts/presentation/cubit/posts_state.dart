import 'package:equatable/equatable.dart';
import '../../domain/entities/post_entity.dart';

class PostsState extends Equatable {
  final bool loading;
  final List<PostEntity> posts;
  final String? error;

  const PostsState._({
    required this.loading,
    required this.posts,
    this.error,
  });

  const PostsState.initial()
      : this._(loading: false, posts: const <PostEntity>[]);
  const PostsState.loading()
      : this._(loading: true, posts: const <PostEntity>[]);
  const PostsState.success(List<PostEntity> posts)
      : this._(loading: false, posts: posts);
  const PostsState.failure(String message)
      : this._(
          loading: false,
          posts: const <PostEntity>[],
          error: message,
        );

  @override
  List<Object?> get props => [loading, posts, error];
}


