import 'dart:collection';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/layout/default_layout.dart';
import 'package:tot/common/view/first_page_view.dart';
import 'package:tot/common/view/root_tab.dart';
import 'package:tot/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kakao.KakaoSdk.init(nativeAppKey: '65883b79301a6a8e7b88ab503dfc2959');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    _App(),
  );
}

Future<FirebaseApp> _load() async {
  var temp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if(Platform.isAndroid) {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
  }else if(Platform.isIOS){
    final authStatus = await FirebaseMessaging.instance.requestPermission();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
  }

  if (FirebaseAuth.instance.currentUser != null &&
      !FirebaseAuth.instance.currentUser!.isAnonymous) {
    await getBookmarkByLoad();
  }
  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
    print(FirebaseAuth.instance.currentUser!.isAnonymous);
  }
  // print(API.dio.options.headers);
  // await getKeywordListByLoad();
  await getKeywordRankByLoad();
  return temp;
}

Future<void> getBookmarkByLoad() async {
  await API.changeDioToken();
  final bookmark = await API.getUserBookmark();
  if (bookmark != null) {
    userBookmark = bookmark.map((e) => e.id).toList();
  } else {
    userBookmark = [];
  }
}

Future<void> getKeywordRankByLoad() async {
  final temp = await API.getKeywordRank();
  keywordList.addAll(temp!);
}

// Future<void> getKeywordListByLoad() async {
//   final temp = await Future.wait(
//       [_getKeywordListPage(2), _getKeywordListPage(1), _getKeywordListPage(0)]);
//   temp[0].addAll(temp[1]);
//   temp[0].addAll(temp[2]);
//   var _keywordList = SplayTreeMap<int, List<String>?>.from(temp[0]);
//   keywordList = [];
//   for (final int key in _keywordList.keys) {
//     if (_keywordList != null) {
//       keywordList.addAll(_keywordList[key]!);
//     }
//   }
// }
//
// Future<Map<int, List<String>?>> _getKeywordListPage(int page) async {
//   List<String>? temp = await API.getKeywordRank(page);
//   if (temp!.isEmpty) return {page: []};
//   Map<int, List<String>?> val = await _getKeywordListPage(page + 3);
//   val[page] = temp;
//   return val;
// }

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(430.0, 932.0),
      builder: (context, child) => FutureBuilder(
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
              home: FirebaseAuth.instance.currentUser!.isAnonymous
                  ? FirstPageView()
                  : RootTab(),
              builder: (context, child) {
                return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child!);
              },
            );
          }
          // 로딩 페이지
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }
}
