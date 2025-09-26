import 'package:dio/dio.dart';
import '../models/post.dart';
import 'package:flutter/foundation.dart'; 

class PostsApi {
  final Dio dio;
  PostsApi(this.dio);

  // Toggle for simulating an error:
  // true = wrong path (error), false = normal '/posts'
  static bool kUseBadPath = false;

  Future<List<PostModel>> fetchPosts() async {
    // Choose endpoint based on toggle
    final path = kUseBadPath ? '/postz' : '/posts';
    debugPrint('REQUEST path=$path baseUrl=${dio.options.baseUrl}'); 

    try {
      // Send GET request
      final res = await dio.get(path);

      // Parse response JSON into PostModel list
      final data = res.data as List<dynamic>;
      return data.map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      // Log and rethrow on network/API error
      debugPrint('API ERROR: $e');
      rethrow;
    }
  }
}




