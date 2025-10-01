import '../entities/post_entity.dart';

/// Domain: abstract repository interface
abstract class PostsRepository {
  Future<List<PostEntity>> getPosts({int start, int limit});
}


