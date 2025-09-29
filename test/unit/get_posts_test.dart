// test/unit/get_posts_test.dart
//
// Unit test for the GetPosts use-case.
// We mock the PostsRepository so the test runs offline and focuses only on
// verifying that the use-case returns data (or rethrows errors).

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_posts_demo/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_posts_demo/features/posts/domain/repositories/posts_repository.dart';
import 'package:flutter_posts_demo/features/posts/domain/usecases/get_posts.dart';

/// Mock implementation of the repository dependency.
class _MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  late _MockPostsRepository repo;
  late GetPosts getPosts;

  setUp(() {
    repo = _MockPostsRepository();
    getPosts = GetPosts(repo); // SUT (System Under Test)
  });

  test('returns a list of PostEntity from repository', () async {
    // Arrange
    when(() => repo.getPosts()).thenAnswer(
      (_) async => [PostEntity(id: 1, userId: 1, title: 'ok', body: 'body')],
    );

    // Act
    final result = await getPosts();

    // Assert
    expect(result, isA<List<PostEntity>>());
    expect(result.single.title, 'ok');
    verify(() => repo.getPosts()).called(1);
  });

  test('rethrows repository exceptions', () async {
    // Arrange
    when(() => repo.getPosts()).thenThrow(Exception('boom'));

    // Act & Assert
    expect(() => getPosts(), throwsA(isA<Exception>()));
    verify(() => repo.getPosts()).called(1);
  });
}





