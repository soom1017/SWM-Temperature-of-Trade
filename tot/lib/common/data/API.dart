import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tot/common/data/news_tile_data.dart';

import 'news_data.dart';

Future<String> getIdToken() async {
  return await FirebaseAuth.instance.currentUser!.getIdToken();
}

Dio dioSetting() {
  final dio = Dio();
  dio.options.baseUrl = "http://43.201.79.31:8000";
  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['Content-Type'] = 'application/json';
  return dio;
}

abstract class API {
  static String getUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static var dio = dioSetting();

  static changeDioToken() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String temp = await FirebaseAuth.instance.currentUser!.getIdToken();
      dio.options.headers['Authorization'] = 'Bearer ${temp}';
    } else {
      dio.options.headers.remove('Authorization');
    }
  }

  // news api
  static Future<NewsData?> getNewsById(int newsId) async {
    try {
      final response = await dio.get("/news/${newsId}");
      return NewsData.fromResponse(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<NewsTileData>?> getNewsListNew({int news_id = -1}) async {
    try {
      final response = await dio.get("/news/list-new/${news_id}");
      return List<Map<String, dynamic>>.from(response.data['data'])
          .map((e) => NewsTileData.fromResponse(e))
          .toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<NewsTileData>?> getNewsListHot({int news_id = -1}) async {
    try {
      final response = await dio.get("/news/list-hot/${news_id}");
      return List<Map<String, dynamic>>.from(response.data['data'])
          .map((e) => NewsTileData.fromResponse(e))
          .toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<NewsTileData>?> getNewsListByKeyword(String keywordName,
      {int news_id = -1}) async {
    try {
      final response =
          await dio.get("/news/keyword/$keywordName/$news_id");
      return List<Map<String, dynamic>>.from(response.data['data'])
          .map((e) => NewsTileData.fromResponse(e))
          .toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> createBookmarkById(int newsId) async {
    try {
      final response = await dio.get("/users/create/bookmark/$newsId");
      return "success";
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<String?> deleteBookmarkById(int newsId) async {
    try {
      final response = await dio.get("/users/delete/bookmark/$newsId");
      return "success";
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<List<NewsTileData>?> getUserBookmark() async {
    try {
      final response = await dio.get("/users/bookmarks");
      return List<Map<String, dynamic>>.from(response.data['data'])
          .map((e) => NewsTileData.fromResponse(e))
          .toList();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<List<String>?> getKeywordRank(int pageOffset) async {
    try {
      final response = await dio.get("/keywords/rank/$pageOffset");
      return List<String>.from(response.data['data'])
          .map((e) => e.toString())
          .toList();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getGraphMapByKeyword(String keywordName) async {
    try {
      final response = await dio.get("/keywords/map/$keywordName");
      return response.data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}