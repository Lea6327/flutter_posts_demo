import '../domain/entities/post_entity.dart';
import '../domain/repositories/posts_repository.dart';
import 'sources/posts_api.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsApi api;
  PostsRepositoryImpl(this.api);

  @override
  Future<List<PostEntity>> getPosts() async {
    // PostModel extends PostEntity, so it can be returned directly
    final models = await api.fetchPosts();
    return models;
  }
}


