import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPosts {
  final PostsRepository repo;
  const GetPosts(this.repo);

  Future<List<PostEntity>> call() => repo.getPosts();
}

