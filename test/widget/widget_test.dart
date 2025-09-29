// test/widget/widget_test.dart
//
// Widget tests for PostsPage. We mock the GetPosts use-case so the UI can
// be verified without hitting the network. The page uses a real PostsCubit.
// NOTE: We no longer assert on a spinner because the app uses a skeleton list;
// instead we assert that the list appears on success and "Retry" appears on error.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_posts_demo/features/posts/presentation/pages/posts_page.dart';
import 'package:flutter_posts_demo/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:flutter_posts_demo/features/posts/domain/usecases/get_posts.dart';
import 'package:flutter_posts_demo/features/posts/domain/entities/post_entity.dart';

/// Mock of the parameterless GetPosts call().
class _MockGetPosts extends Mock implements GetPosts {}

void main() {
  testWidgets('renders list after successful fetch', (tester) async {
    // Arrange: the use-case returns one post.
    final mockGetPosts = _MockGetPosts();
    when(() => mockGetPosts()).thenAnswer(
      (_) async => [PostEntity(id: 1, userId: 1, title: 'Test Title', body: 'Test body')],
    );

    // Pump PostsPage with a real PostsCubit.
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => PostsCubit(mockGetPosts),
          child: const PostsPage(),
        ),
      ),
    );

    // PostsPage.initState() calls fetch(); wait for async/rebuilds to finish.
    await tester.pumpAndSettle();

    // Assert: the fetched title is rendered; list exists (RefreshIndicator wraps ListView).
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows error view with Retry when fetch fails', (tester) async {
    // Arrange: the use-case throws.
    final mockGetPosts = _MockGetPosts();
    when(() => mockGetPosts()).thenThrow(Exception('boom'));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => PostsCubit(mockGetPosts),
          child: const PostsPage(),
        ),
      ),
    );

    // Wait for the error state to render.
    await tester.pumpAndSettle();

    // Assert: ErrorView appears (at least a "Retry" button is present).
    expect(find.textContaining('Retry'), findsOneWidget);
  });
}


