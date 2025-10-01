import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

/// Use case wrapper
class GetPosts {
  final PostsRepository repo;
  GetPosts(this.repo);

  Future<List<PostEntity>> call({int start = 0, int limit = 20}) {
    return repo.getPosts(start: start, limit: limit);
  }
}




