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
  final bool hasMore;
  const PostsLoaded(this.posts, {this.hasMore = true});
}

class PostsError extends PostsState {
  final String message;
  const PostsError(this.message);
}

// ---------- Cubit ----------
class PostsCubit extends Cubit<PostsState> {
  final GetPosts _getPosts;
  PostsCubit(this._getPosts) : super(const PostsInitial());

  int _page = 0;
  final int _limit = 20;
  final List<PostEntity> _all = [];
  bool _busy = false;
  bool _hasMore = true;

  Future<void> fetch({bool refresh = false}) async {
    if (_busy) return;
    _busy = true;

    if (refresh) {
      _page = 0;
      _all.clear();
      _hasMore = true;
      emit(const PostsLoading());
    }

    try {
      final posts = await _getPosts(start: _page * _limit, limit: _limit);

      if (posts.isEmpty) {
        _hasMore = false;
      } else {
        _all.addAll(posts);
        _page++;
        // last page when result count < page size
        if (posts.length < _limit) {
          _hasMore = false;
        }
      }

      emit(PostsLoaded(List.of(_all), hasMore: _hasMore));
    } catch (_) {
      emit(const PostsError('Oops! Failed to load posts. Please try again.'));
    } finally {
      _busy = false;
    }
  }
}







