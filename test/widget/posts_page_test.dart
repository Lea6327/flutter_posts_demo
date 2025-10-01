import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_posts_demo/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_posts_demo/features/posts/domain/usecases/get_posts.dart';
import 'package:flutter_posts_demo/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:flutter_posts_demo/features/posts/presentation/pages/posts_page.dart';

class _MockGetPosts extends Mock implements GetPosts {}

void main() {
  testWidgets('shows success list after fetching', (tester) async {
    // Arrange
    final usecase = _MockGetPosts();
    when(() => usecase(
          start: any(named: 'start'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => const [
          PostEntity(id: 1, userId: 1, title: 'ok', body: 'body'),
          PostEntity(id: 2, userId: 1, title: 'foo', body: 'bar'),
        ]);

    // Real cubit with mocked use case
    final cubit = PostsCubit(usecase);
    addTearDown(cubit.close);

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const PostsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle(); // wait for async fetch

    // Assert
    expect(find.text('ok'), findsOne);
    expect(find.text('foo'), findsOne);
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows error view with Retry when fetching fails', (tester) async {
    // Arrange
    final usecase = _MockGetPosts();
    when(() => usecase(
          start: any(named: 'start'),
          limit: any(named: 'limit'),
        )).thenThrow(Exception('boom'));

    final cubit = PostsCubit(usecase);
    addTearDown(cubit.close);

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const PostsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(find.textContaining('Retry'), findsOneWidget);
  });
}




