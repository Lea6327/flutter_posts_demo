import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_posts_demo/features/posts/data/sources/posts_api.dart';
import 'package:flutter_posts_demo/features/posts/data/posts_repository.dart';
import 'package:flutter_posts_demo/features/posts/data/models/post.dart';

class _MockPostsApi extends Mock implements PostsApi {}

void main() {
  late _MockPostsApi api;
  late PostsRepositoryImpl repo;

  setUp(() {
    api = _MockPostsApi();
    repo = PostsRepositoryImpl(api);
  });

  test('getPosts returns list from api', () async {
    final posts = const [
      Post(id: 1, userId: 1, title: 'Hello', body: 'World'),
      Post(id: 2, userId: 1, title: 'Foo', body: 'Bar'),
    ];
    when(() => api.fetchPosts()).thenAnswer((_) async => posts);

    final result = await repo.getPosts();

    expect(result, posts);
    verify(() => api.fetchPosts()).called(1);
  });

  test('getPosts rethrows api error', () {
    when(() => api.fetchPosts()).thenThrow(Exception('network down'));

    // don’t await here—expect directly on the Future
    expect(repo.getPosts(), throwsA(isA<Exception>()));
    verify(() => api.fetchPosts()).called(1);
  });
}
