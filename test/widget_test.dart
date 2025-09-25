import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_posts_demo/features/posts/data/models/post.dart';
import 'package:flutter_posts_demo/features/posts/data/posts_repository.dart';
import 'package:flutter_posts_demo/main.dart';

class _FakeRepo implements PostsRepository {
  final bool shouldFail;
  _FakeRepo({this.shouldFail = false});

  @override
  Future<List<Post>> getPosts() async {
    if (shouldFail) throw Exception('boom');
    return [
      const Post(id: 1, userId: 99, title: 'ok', body: 'body'), // ✅ add userId
    ];
  }
}

void main() {
  testWidgets('shows list after loading', (tester) async {
    await tester.pumpWidget(MyApp(repo: _FakeRepo()));

    // first frame: loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // wait for async load
    await tester.pumpAndSettle();

    // list item rendered
    expect(find.text('ok'), findsOneWidget);
  });

  testWidgets('shows error and retry button on failure', (tester) async {
    await tester.pumpWidget(MyApp(repo: _FakeRepo(shouldFail: true)));

    await tester.pumpAndSettle();

    // error UI appears
    expect(find.textContaining('boom'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}


