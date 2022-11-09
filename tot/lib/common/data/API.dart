import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tot/common/data/chart_data.dart';
import 'package:tot/common/data/news_tile_data.dart';

import 'news_data.dart';

Dio dioSetting() {
  final dio = Dio();
  dio.options.baseUrl = "http://43.201.79.31:8000";
  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['Content-Type'] = 'application/json';
  return dio;
}

abstract class API {
  static var dio = dioSetting();

  static changeDioToken() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String temp = await FirebaseAuth.instance.currentUser!.getIdToken(true);
      dio.options.headers['Authorization'] = 'Bearer ${temp}';
    } else {
      dio.options.headers.remove('Authorization');
    }
  }

  // news api
  static Future<NewsData> getNewsById(int newsId) async {
    final response = await dio.get("/news/${newsId}");
    return NewsData.fromResponse(response.data);
  }

  static Future<List<NewsTileData>> getNewsListNew({int news_id = -1}) async {
    final response = await dio.get("/news/list-new/${news_id}");
    return List<Map<String, dynamic>>.from(response.data['data'])
        .map((e) => NewsTileData.fromResponse(e))
        .toList();
  }

  static Future<List<NewsTileData>> getNewsListHot({int news_id = -1}) async {
    final response = await dio.get("/news/list-hot/${news_id}");
    return List<Map<String, dynamic>>.from(response.data['data'])
        .map((e) => NewsTileData.fromResponse(e))
        .toList();
  }

  static Future<List<NewsTileData>> getNewsListByKeyword(String keywordName,
      {int news_id = -1}) async {
    final response = await dio.get("/news/keyword/$keywordName/$news_id");
    return List<Map<String, dynamic>>.from(response.data['data'])
        .map((e) => NewsTileData.fromResponse(e))
        .toList();
  }

  static Future<String> createBookmarkById(int newsId) async {
    final response = await dio.get("/users/create/bookmark/$newsId");
    return "success";
  }

  static Future<String> deleteBookmarkById(int newsId) async {
    final response = await dio.get("/users/delete/bookmark/$newsId");
    return "success";
  }

  static Future<List<NewsTileData>> getUserBookmark() async {
    final response = await dio.get("/users/bookmarks");
    return List<Map<String, dynamic>>.from(response.data['data'])
        .map((e) => NewsTileData.fromResponse(e))
        .toList();
  }

  static Future<List<String>> getKeywordRank() async {
    final response = await dio.get("/keywords/rank");
    return List<String>.from(response.data['data'])
        .map((e) => e.toString())
        .toList();
  }

  static Future<Map<String, dynamic>> getGraphMapByKeyword(
      String keywordName) async {
    final response = await dio.get("/keywords/map/$keywordName");
    return response.data;
  }

  static Future<Map<String, List<String>>> getFilterKeyword() async {
    final response = await dio.get("/keywords/");
    return {
      "keywords": List<String>.from(response.data["keywords"]),
      "stocks": List<String>.from(response.data["stocks"])
    };
  }

  static Future<List<ChartData>> getSentimentStats() async {
    final response = await dio.get("/news/stats-sentiment/");
    Map<String, dynamic> x = response.data['data'];
    List<ChartData>? ans = [];
    for (var e in x.keys) {
      double neutral = x[e]![0].toDouble();
      double positive = x[e]![1].toDouble();
      double negative = x[e]![2].toDouble();
      double t = (positive + negative) == 0.0
          ? 0.0
          : (positive - negative) / (positive + negative);
      ans.add(ChartData(DateTime.parse(e), neutral, positive, negative, t));
    }
    return ans.reversed.toList();
  }

  static Future<List<NewsTileData>?> getNewsListByFilter(
  Map<String, List<String>> keyList, {int newsId = -1}) async {
    final response =
        await API.dio.post("/news/list-filter/$newsId", data: keyList);
    return List<Map<String, dynamic>>.from(response.data['data'])
        .map((e) => NewsTileData.fromResponse(e))
        .toList();
  }
}

Future<dynamic> tokenCheck(func) async {
  try {
    return await func();
  } on DioError catch (e) {
    if (e.response!.statusCode == 401) {
      await API.changeDioToken();
      return await func();
    } else {
      return null;
    }
  }
}
