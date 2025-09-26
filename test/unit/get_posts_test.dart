
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


import 'package:flutter_posts_demo/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_posts_demo/features/posts/domain/repositories/posts_repository.dart';
import 'package:flutter_posts_demo/features/posts/domain/usecases/get_posts.dart';

class _MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  late _MockPostsRepository repo;
  late GetPosts getPosts;

  setUp(() {
    repo = _MockPostsRepository();
    getPosts = GetPosts(repo); // class GetPosts 
  });

  test('GetPosts returns list from repository', () async {
    // Arrange
    when(() => repo.getPosts()).thenAnswer(
      (_) async => [
        PostEntity(id: 1, userId: 1, title: 'ok', body: 'body'), // userId
      ],
    );

    // Act
    final result = await getPosts();

    // Assert
    expect(result, isA<List<PostEntity>>());
    expect(result.single.title, 'ok');
    verify(() => repo.getPosts()).called(1);
  });

  test('GetPosts rethrows repository exception', () async {
    // Arrange
    when(() => repo.getPosts()).thenThrow(Exception('boom'));

    // Act & Assert
    expect(() => getPosts(), throwsA(isA<Exception>()));
    verify(() => repo.getPosts()).called(1);
  });
}



