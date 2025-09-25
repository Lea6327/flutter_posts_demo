import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_posts.dart';
import 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final GetPosts getPosts;

  // Constructor: initialize with an initial state
  PostsCubit(this.getPosts) : super(const PostsState.initial());

  // Load posts from repository / use case
  Future<void> load() async {
    // 1. Emit loading state so the UI can show a spinner
    emit(const PostsState.loading());

    // 2. Add a short artificial delay so that the loading indicator
    //    is visible for demonstration purposes.
    //    In real apps, you can remove or shorten this.
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      // 3. Try to get posts from the use case (domain layer)
      final posts = await getPosts();

      // 4. If successful, emit a success state with the fetched posts
      emit(PostsState.success(posts));
    } catch (e) {
      // 5. If an error occurs, print it (for debugging)
      //    and emit a failure state with the error message
      // ignore: avoid_print
      print('LOAD ERROR: $e');
      emit(PostsState.failure(e.toString()));
    }
  }
}

