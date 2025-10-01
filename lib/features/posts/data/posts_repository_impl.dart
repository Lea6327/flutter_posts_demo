import '../domain/entities/post_entity.dart';
import '../domain/repositories/posts_repository.dart';
import 'sources/posts_api.dart';

/// Data: repository implementation
class PostsRepositoryImpl implements PostsRepository {
  final PostsApi api;
  PostsRepositoryImpl(this.api);

  @override
  Future<List<PostEntity>> getPosts({int start = 0, int limit = 20}) {
    return api.fetchPosts(start: start, limit: limit);
  }
}






