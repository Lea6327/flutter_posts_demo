
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/post.dart';

class PostsApi {
  final Dio dio;
  PostsApi(this.dio);

  /// Toggle to simulate an error.
  /// - true  = wrong endpoint (will throw an error)
  /// - false = correct endpoint '/posts'
  static bool kUseBadPath = false;

  Future<List<PostModel>> fetchPosts() async {
    // Decide which path to call depending on the toggle
    final path = kUseBadPath ? '/postz' : '/posts';
    debugPrint('REQUEST path=$path  baseUrl=${dio.options.baseUrl}');

    try {
      // Perform GET request to the API
      final res = await dio.get(path);
      debugPrint('RESP ${res.statusCode}  ${res.realUri}'); // Log final URL

      // Parse the response JSON into a list of PostModel objects
      final data = (res.data as List).cast<Map<String, dynamic>>();
      return data.map(PostModel.fromJson).toList();
    } on DioException catch (e) {
      // Print API/network error for debugging and rethrow
      debugPrint('API ERROR: ${e.message}');
      rethrow;
    }
  }
}





