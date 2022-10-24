import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/layout/default_layout.dart';
import 'package:tot/common/view/root_tab.dart';
import 'package:tot/firebase_options.dart';
import 'package:tot/graph.dart';
import 'package:tot/login/view/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kakao.KakaoSdk.init(nativeAppKey: '65883b79301a6a8e7b88ab503dfc2959');
  runApp(
    _App(),
  );
}

Future<FirebaseApp> _load() async{
  var temp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if(FirebaseAuth.instance.currentUser != null && !FirebaseAuth.instance.currentUser!.isAnonymous) {
    await getBookmarkByLoad();
  }
  if(FirebaseAuth.instance.currentUser == null)
  {
    await FirebaseAuth.instance.signInAnonymously();
    print(FirebaseAuth.instance.currentUser!.isAnonymous);
  }
  // print(API.dio.options.headers);
  await getKeywordListByLoad();
  return temp;
}

Future<void> getBookmarkByLoad() async{
  await API.changeDioToken();
  final bookmark = await API.getUserBookmark();
  if(bookmark != null) {
    userBookmark = bookmark.map((e) => e.id).toList();
  }else{
    userBookmark = [];
  }
  print(userBookmark);
}

Future<void> getKeywordListByLoad() async{
  final temp = await Future.wait([_getKeywordListPage(2), _getKeywordListPage(1), _getKeywordListPage(0)]);
  temp[0].addAll(temp[1]);
  temp[0].addAll(temp[2]);
  var _keywordList = SplayTreeMap<int, List<String>?>.from(temp[0]);
  keywordList = [];
  for(final int key in _keywordList.keys){
    if(_keywordList != null) {
      keywordList.addAll(_keywordList[key]!);
    }
  }
}

Future<Map<int, List<String>?>> _getKeywordListPage(int page) async{
  List<String>? temp = await API.getKeywordRank(page);
  if(temp!.isEmpty) return {page: []};
  Map<int, List<String>?> val = await _getKeywordListPage(page+3);
  val[page] = temp;
  return val;
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _load(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DefaultLayout(
              child: Center(
                child: Text("Firebase load fail"),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: RootTab(),
          );
          // return MyApp();
        }
        // 로딩 페이지
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DefaultLayout(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
//
// class _AuthApp extends StatelessWidget {
//   const _AuthApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
//         if (!snapshot.hasData) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             home: DefaultLayout(
//               child: LoginScreen(),
//             ),
//           );
//         } else {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             home: RootTab(),
//           );
//         }
//       },
//     );
//   }
// }
