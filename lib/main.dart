import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/dio_client.dart';
import 'features/posts/data/sources/posts_api.dart';
import 'features/posts/data/posts_repository.dart';
import 'features/posts/domain/usecases/get_posts.dart';
import 'features/posts/presentation/cubit/posts_cubit.dart';
import 'features/posts/presentation/pages/posts_page.dart';
import 'theme/app_theme.dart';

void main() {
  final dio = buildDio();
  final api = PostsApi(dio);
  final repo = PostsRepositoryImpl(api);
  final getPosts = GetPosts(repo);

  runApp(MyApp(getPosts: getPosts));
}

class MyApp extends StatelessWidget {
  final GetPosts getPosts;
  const MyApp({super.key, required this.getPosts});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Posts Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (_) => PostsCubit(getPosts),
        child: const PostsPage(),
      ),
    );
  }
}



