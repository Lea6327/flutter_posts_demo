import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/post.dart';

class PostsApi {
  final Dio dio;
  PostsApi(this.dio);

  /// Debug toggle to simulate an API error.
  /// true  -> use a wrong path to force failure
  /// false -> use the correct '/posts' endpoint
  static bool kUseBadPath = false;

  /// Fetch posts with pagination.
  /// - [start]: offset (JSONPlaceholder supports `_start`)
  /// - [limit]: page size (JSONPlaceholder supports `_limit`)
  ///

  Future<List<PostModel>> fetchPosts({
    int start = 0,
    int limit = 20,
    CancelToken? cancelToken,
  }) async {
    final path = kUseBadPath ? '/postz' : '/posts';

    // record request info
    debugPrint('REQUEST path=$path baseUrl=${dio.options.baseUrl} start=$start limit=$limit');

    try {
      final res = await dio.get(
        path,
        queryParameters: {
          '_start': start,
          '_limit': limit,
        },
        cancelToken: cancelToken,
      );

      debugPrint('RESP ${res.statusCode}  ${res.realUri}'); // final url

      final raw = res.data;
      if (raw is! List) {
        throw DioException(
          requestOptions: res.requestOptions,
          response: res,
          type: DioExceptionType.badResponse,
          error: 'Unexpected response shape: not a List',
        );
      }

      final list = raw.cast<Map<String, dynamic>>();
      return list.map(PostModel.fromJson).toList(growable: false);
    } on DioException catch (e) {
      // detail error info
      debugPrint('[API ERROR] type=${e.type} status=${e.response?.statusCode} url=${e.requestOptions.uri}');
      debugPrint('message=${e.message}');
      rethrow;
    }
  }

  /// page from 0
  Future<List<PostModel>> fetchPage({
    int page = 0,
    int pageSize = 20,
    CancelToken? cancelToken,
  }) {
    final start = page * pageSize;
    return fetchPosts(start: start, limit: pageSize, cancelToken: cancelToken);
  }
}










