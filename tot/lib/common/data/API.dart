import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tot/common/data/news_tile_data.dart';

import 'news_data.dart';

Dio dioSetting(){
  final dio = Dio();
  dio.options.baseUrl = "http://43.201.79.31:8000";
  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['Content-Type'] = 'application/json';
  return dio;
}

abstract class API {
  static String getUid(){
    return FirebaseAuth.instance.currentUser!.uid;
  }
  static final dio = dioSetting();
  // news api
  static Future<NewsData?> getNewsById(int news_id) async {
    try {
      final response = await dio.get("/news/${news_id}");
      return NewsData.fromResponse(response.data);
    } catch(e){
      print(e);
      return null;
    }
  }

  static Future<List<NewsTileData>?> getNewsListNew({int news_id = -1}) async {
    try {
      final response = await dio.get("/news/list-new/${news_id}");
      return List<Map<String, dynamic>>.from(response.data['data']).map((e) => NewsTileData.fromResponse(e)).toList();
    } catch(e){
      print(e);
      return null;
    }
  }

  static Future<List<NewsTileData>?> getNewsListHot({int news_id = -1}) async {
    try {
      final response = await dio.get("/news/list-hot/${news_id}");
      return List<Map<String, dynamic>>.from(response.data['data']).map((e) => NewsTileData.fromResponse(e)).toList();
    } catch(e){
      print(e);
      return null;
    }
  }

  static Future<List<NewsTileData>?> getNewsListByKeyword(String keyword_name, {int news_id = -1}) async {
    try {
      final response = await dio.get("/news/keyword/${keyword_name}/${news_id}");
      return List<Map<String, dynamic>>.from(response.data['data']).map((e) => NewsTileData.fromResponse(e)).toList();
    } catch(e){
      print(e);
      return null;
    }
  }
}