import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_posts_demo/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_posts_demo/features/posts/domain/usecases/get_posts.dart';
import 'package:flutter_posts_demo/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:flutter_posts_demo/features/posts/presentation/pages/posts_page.dart';

class _MockRepo extends Mock implements GetPosts {}

void main() {
  testWidgets('shows loading then success list', (tester) async {
    final repo = _MockRepo();
    when(() => repo()).thenAnswer(
      (_) async => [const PostEntity(id: 1, userId: 1, title: 'ok', body: 'body')],
    );

    final cubit = PostsCubit(repo);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const PostsPage(),
        ),
      ),
    );

    // First frame: should show loading spinner
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for Cubit to emit success state
    await tester.pump(const Duration(seconds: 1));

    // Should show the post title
    expect(find.text('ok'), findsOneWidget);
  });

  testWidgets('shows error and Retry button on failure', (tester) async {
    final repo = _MockRepo();
    when(() => repo()).thenThrow(Exception('boom'));

    final cubit = PostsCubit(repo);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const PostsPage(),
        ),
      ),
    );

    // First frame: should show loading spinner
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for error state (>400ms delay + emit)
    await tester.pump(const Duration(seconds: 1));

    // Flexible assertions: accept Exception text, error icon, and Retry button
    expect(find.textContaining('Exception'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}


