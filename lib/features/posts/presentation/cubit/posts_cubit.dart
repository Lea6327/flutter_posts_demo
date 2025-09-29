import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../posts/domain/usecases/get_posts.dart';
import '../../../posts/domain/entities/post_entity.dart'; 

// ---------- States ----------
abstract class PostsState {
  const PostsState();
}

class PostsInitial extends PostsState {
  const PostsInitial();
}

class PostsLoading extends PostsState {
  const PostsLoading();
}

class PostsLoaded extends PostsState {
  final List<PostEntity> posts; 
  const PostsLoaded(this.posts);
}

class PostsError extends PostsState {
  final String message;
  const PostsError(this.message);
}

// ---------- Cubit ----------
class PostsCubit extends Cubit<PostsState> {
  final GetPosts _getPosts;
  PostsCubit(this._getPosts) : super(const PostsInitial());

  Future<void> fetch() async {
    emit(const PostsLoading());
    try {
      final posts = await _getPosts(); // Future<List<PostEntity>>
      emit(PostsLoaded(posts));        
    } catch (_) {
      emit(const PostsError('Oops! Failed to load posts. Please try again.'));
    }
  }
}




