import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'features/posts/presentation/cubit/posts_cubit.dart';
import 'features/posts/presentation/pages/posts_page.dart';

import 'features/posts/data/sources/posts_api.dart';
import 'features/posts/data/posts_repository_impl.dart';
import 'features/posts/domain/usecases/get_posts.dart';

void main() {
  // Wire up dependencies
  final dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
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
      debugShowCheckedModeBanner: false, 
      title: 'Posts Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: BlocProvider(
        create: (_) => PostsCubit(getPosts),
        child: const PostsPage(),
      ),
    );
  }
}




