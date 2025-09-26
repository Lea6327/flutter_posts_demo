import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart'; // 👈 add this
import '../../domain/usecases/get_posts.dart';
import 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final GetPosts getPosts;
  PostsCubit(this.getPosts) : super(const PostsState.initial());

  Future<void> load() async {
    emit(const PostsState.loading());
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final posts = await getPosts();
      emit(PostsState.success(posts));
    } catch (e) {
      // print -> debugPrint 
      debugPrint('LOAD ERROR: $e');
      emit(PostsState.failure(e.toString()));
    }
  }
}


