import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'NEWS',
//         theme: ThemeData(
//             appBarTheme: const AppBarTheme(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black
//             )
//         ),
//         home: const JsonNews()
//     );
//   }
// }

class JsonNewsState extends State<JsonNews> {
  late Future<List<Json>> futureJsonList;

  @override
  void initState() {
    super.initState();
    futureJsonList = fetchJsonList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }

  void _pushSaved(Json article) {
    Navigator.of(context).push(
      // Add lines from here...
      MaterialPageRoute<void>(
        builder: (context) {
          final senlen = article.sentences.length;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Highlighting'),
            ),
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Text.rich(
                    TextSpan(
                      children: _getHighlighting(
                          article.sentences, article.highlightIdx),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ), // ...to here.
    );
  }

  List<TextSpan> _getHighlighting(
      List<List<String>> article, List<int> highlight) {
    final List<TextSpan> temp = [];
    var cnt = 0;
    for (var list in article) {
      for (var news in list) {
        if (highlight.indexWhere((element) => element == cnt) >= 0) {
          temp.add(TextSpan(
              text: news.toString(),
              style: const TextStyle(
                backgroundColor: Colors.yellow,
              )));
        } else {
          temp.add(TextSpan(text: news.toString()));
        }
        cnt++;
      }
      temp.add(const TextSpan(text: '\n\n'));
    }
    return temp;
  }

  Widget _buildSuggestions() {
    return FutureBuilder<List<Json>>(
      future: futureJsonList,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          debugPrint('error occur');
        }
        // 정상적으로 데이터가 수신된 경우
        return snapshot.hasData
            ? _newsList(snapshot.data!)
            : const Center(
                child: CircularProgressIndicator()); // 데이터 수신 전이면 인디케이터 출력
      },
    );
  }

  Widget _newsList(List<Json> snapdata) {
    return Column(
      children: [
        Text(snapdata[widget.number].summary, style: TextStyle(fontWeight: FontWeight.w600),),
        Divider(thickness: 4.0, color: Colors.grey,),
        Text.rich(
          TextSpan(
            children: _getHighlighting(
                snapdata[widget.number].sentences, snapdata[widget.number].highlightIdx),
          ),
        ),
      ],
    );
    // return ListView.separated(
    //   padding: const EdgeInsets.all(16.0),
    //   itemCount: snapdata.length,
    //   itemBuilder: (context, index){
    //     var article = snapdata[index];
    //     return ListTile(
    //         title: Text((index + 1).toString(),
    //           style: const TextStyle(
    //             fontSize: 25,
    //           ),),
    //         onTap: (){
    //           setState(() {
    //             _pushSaved(article);
    //           });
    //         }
    //     );
    //   },
    //   separatorBuilder: (BuildContext context, int index) => const Divider(),
    // );
  }
}

class JsonNews extends StatefulWidget {
  final int number;
  const JsonNews({required this.number, Key? key}) : super(key: key);

  @override
  JsonNewsState createState() => JsonNewsState();
}

List<Json> parseNews(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Json>((json) => Json.fromJson(json)).toList();
}

Future<List<Json>> fetchJsonList() async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/wxogus25/startup/master/ts.json'));
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

class Json {
  final String summary;
  final List<List<String>> sentences;
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
    List<List<String>> sentenceList = [];
    sentencesFromJson.values.toList().forEach((list) {
      sentenceList.add(list?.cast<String>());
    });
    return Json(
      summary: parsedJson['summary'],
      sentences: sentenceList,
      highlightIdx: highlightIdxList,
    );
  }
}
