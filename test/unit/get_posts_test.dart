import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_posts_demo/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_posts_demo/features/posts/domain/repositories/posts_repository.dart';
import 'package:flutter_posts_demo/features/posts/domain/usecases/get_posts.dart';

class MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  late MockPostsRepository repo;
  late GetPosts usecase;

  setUp(() {
    repo = MockPostsRepository();
    usecase = GetPosts(repo);
  });

  test('returns a list of PostEntity from repository', () async {
    final items = const [
      PostEntity(id: 1, userId: 1, title: 't1', body: 'b1'),
      PostEntity(id: 2, userId: 1, title: 't2', body: 'b2'),
    ];

    when(() => repo.getPosts(
          start: any(named: 'start'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => items);

    final result = await usecase(start: 0, limit: 20);

    expect(result, items);
    verify(() => repo.getPosts(
          start: 0,
          limit: 20,
        )).called(1);
  });

  test('rethrows repository exceptions', () async {
    when(() => repo.getPosts(
          start: any(named: 'start'),
          limit: any(named: 'limit'),
        )).thenThrow(Exception('boom'));

    expect(() => usecase(start: 0, limit: 20), throwsException);
  });
}







