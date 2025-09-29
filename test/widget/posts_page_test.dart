import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_posts_demo/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_posts_demo/features/posts/domain/usecases/get_posts.dart';
import 'package:flutter_posts_demo/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:flutter_posts_demo/features/posts/presentation/pages/posts_page.dart';

/// Mock of the parameterless GetPosts() use-case.
class _MockGetPosts extends Mock implements GetPosts {}

void main() {
  testWidgets('shows success list after fetching', (tester) async {
    // Arrange: mock one post returned by the use-case.
    final usecase = _MockGetPosts();
    when(() => usecase()).thenAnswer(
      (_) async => [const PostEntity(id: 1, userId: 1, title: 'ok', body: 'body')],
    );

    // Real cubit with mocked use-case.
    final cubit = PostsCubit(usecase);
    addTearDown(cubit.close);

    // Pump the page. PostsPage.initState() will immediately call fetch().
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const PostsPage(),
        ),
      ),
    );

    // We no longer assert a spinner because loading is a skeleton list.
    // Wait for async work and rebuilds to finish.
    await tester.pumpAndSettle();

    // Assert: the fetched title is rendered; list is present.
    expect(find.text('ok'), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows error view with Retry when fetching fails', (tester) async {
    // Arrange: make the use-case throw.
    final usecase = _MockGetPosts();
    when(() => usecase()).thenThrow(Exception('boom'));

    final cubit = PostsCubit(usecase);
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const PostsPage(),
        ),
      ),
    );

    // Wait for the error state to render.
    await tester.pumpAndSettle();

    // Assert: ErrorView appears; at least a "Retry" button is visible.
    expect(find.textContaining('Retry'), findsOneWidget);
  });
}



