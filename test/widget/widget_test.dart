// Widget tests for PostsPage using a real PostsCubit and a mocked GetPosts.
// The page fetches on initState, so we stub BEFORE pump and then pumpAndSettle.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_posts_demo/features/posts/presentation/pages/posts_page.dart';
import 'package:flutter_posts_demo/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:flutter_posts_demo/features/posts/domain/usecases/get_posts.dart';
import 'package:flutter_posts_demo/features/posts/domain/entities/post_entity.dart';

class _MockGetPosts extends Mock implements GetPosts {}

void main() {
  testWidgets('renders list after successful fetch', (tester) async {
    // Arrange
    final mockGetPosts = _MockGetPosts();
    when(() => mockGetPosts(
          start: any(named: 'start'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => const [
          PostEntity(id: 1, userId: 1, title: 'Test Title', body: 'Test body'),
        ]);

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => PostsCubit(mockGetPosts),
          child: const PostsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows error view with Retry when fetch fails', (tester) async {
    // Arrange
    final mockGetPosts = _MockGetPosts();
    when(() => mockGetPosts(
          start: any(named: 'start'),
          limit: any(named: 'limit'),
        )).thenThrow(Exception('boom'));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => PostsCubit(mockGetPosts),
          child: const PostsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(find.textContaining('Retry'), findsOneWidget);
  });
}



