// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:startup/news.dart';
import 'package:english_words/english_words.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NEWS',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black
            )
        ),
        home: RandomWords()
    );
  }
}

class RandomWordsState extends State<RandomWords>{
  // final _suggestions = <WordPair>[];
  // final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);
  late Future<List<Json>> futureJsonList;

  @override
  void initState(){
    super.initState();
    futureJsonList = fetchJsonList();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text('NEWS'),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.list),
          //     onPressed: _pushSaved,
          //     tooltip: 'Saved Suggestions'
          //   )
          // ],
        ),
        body: _buildSuggestions()
    );
  }

  void _pushSaved(Json article) {
    Navigator.of(context).push(
      // Add lines from here...
      MaterialPageRoute<void>(
        builder: (context) {
          // final tiles = _suggestions.map(
          //       (pair) {
          //     return ListTile(
          //       title: Text(
          //         pair.asPascalCase,
          //         style: _biggerFont,
          //       ),
          //     );
          //   },
          // );
          // final divided = tiles.isNotEmpty
          //     ? ListTile.divideTiles(
          //   context: context,
          //   tiles: tiles,
          // ).toList()
          //     : <Widget>[];

          final _senlen = article.sentences.length;
          final _highlen = article.highlightIdx.length;

          return Scaffold(
              appBar: AppBar(
                title: const Text('Highlighting'),
              ),
              body: Center(
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                          child: Text.rich(
                              TextSpan(children: List.generate(_senlen, (index) {
                                for(int s in article.highlightIdx){
                                  if(index == s) {
                                    return TextSpan(text: article.sentences[index].toString(), style: TextStyle(backgroundColor: Colors.yellow,));
                                  }
                                }
                                return TextSpan(text: article.sentences[index].toString());
                              })))))
              ));
        },
      ), // ...to here.
    );
  }

  Widget _buildSuggestions(){
    return FutureBuilder<List<Json>>(
      future: futureJsonList,
      builder: (context, snapshot){
        if (snapshot.hasError) debugPrint(snapshot.error.toString());
        // 정상적으로 데이터가 수신된 경우
        return snapshot.hasData
            ? _newsList(snapshot.data!)
            : Center(
            child: CircularProgressIndicator()); // 데이터 수신 전이면 인디케이터 출력
      },
    );
  }

  Widget _newsList(List<Json> snapdata){
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: snapdata.length,
      itemBuilder: (context, index){
        var article = snapdata[index];
        return ListTile(
            title: Text((index + 1).toString(),
              style: TextStyle(
                fontSize: 25,
              ),),
            onTap: (){
              setState(() {
                _pushSaved(article);
              });
            }
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

// Widget _buildRow(index, alreadySaved){
//   return ListTile(
//       title: Text(
//         _suggestions[index].asPascalCase,
//         style: _biggerFont,
//       ),
//       onTap: (){
//         setState(() {
//           _pushSaved();
//         });
//       }
//   );
// }
}

class RandomWords extends StatefulWidget{
  @override
  RandomWordsState createState() => RandomWordsState();
}

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
List<Json> parseNews(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Json>((json) => Json.fromJson(json)).toList();
}

Future<List<Json>> fetchJsonList() async {
  final response = await http
      .get(Uri.parse('https://raw.githubusercontent.com/wxogus25/startup/master/ts.json'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return parseNews(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Json{
  final String summary;
  final List<String> sentences;
  final List<int> highlightIdx;

  const Json({
    required this.summary,
    required this.sentences,
    required this.highlightIdx,
  });

  factory Json.fromJson(Map<String, dynamic> parsedJson) {
    var highlightIdxFromJson = parsedJson['highlight_idx'];
    var sentencesFromJson = parsedJson['sentences'];
    List<int> highlightIdxList = List<int>.from(highlightIdxFromJson);
    List<String> sentenceList = List<String>.from(sentencesFromJson);
    print(highlightIdxList[0].toString());
    return Json(
      summary: parsedJson['summary'],
      sentences: sentenceList,
      highlightIdx: highlightIdxList,
    );
  }
}

// class NewsList extends StatelessWidget {
//   late final List<Json> news;
//
//   NewsList({Key? key, List<Json>? news}) : super(key: key){
//     this.news = news!;
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return ListView.separated(
//       padding: const EdgeInsets.all(16.0),
//       itemCount: news.length,
//       itemBuilder: (context, index){
//         var article = news[index];
//         return ListTile(
//           title: Text((index + 1).toString(),
//               style: TextStyle(
//                 fontSize: 25,
//               ),),
//           onTap: (){
//             setState(() {
//               print('test');
//             });
//           }
//         );
//       },
//       separatorBuilder: (BuildContext context, int index) => const Divider(),
//     );
//   }
//
//   // @override
//   // Widget build(BuildContext context){
//   //   return GridView.builder(
//   //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
//   //     itemCount: news.length,
//   //     itemBuilder: (context, index){
//   //       var article = news[index];
//   //       return Container(
//   //           child: Column(
//   //             children: <Widget>[
//   //               Text(article.summary.toString()),
//   //               Text(article.highlightIdx[0].toString())
//   //             ],
//   //           )
//   //       );
//   //     },
//   //   );
//   // }
// }

// void main() => runApp(const MyApp());
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late Future<List<Json>> futureJsonList;
//
//   @override
//   void initState() {
//     super.initState();
//     futureJsonList = fetchJsonList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fetch Data Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Fetch Data Example'),
//         ),
//         body: Center(
//           child: FutureBuilder<List<Json>>(
//             future: futureJsonList,
//             builder: (context, snapshot) {
//               if (snapshot.hasError) debugPrint(snapshot.error.toString());
//               // 정상적으로 데이터가 수신된 경우
//               return snapshot.hasData
//                   ? NewsList(news: snapshot.data)
//                   : Center(
//                   child: CircularProgressIndicator()); // 데이터 수신 전이면 인디케이터 출력
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }