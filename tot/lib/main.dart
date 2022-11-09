import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/AppController.dart';
import 'package:tot/common/data/BookmarkCache.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/layout/default_layout.dart';
import 'package:tot/common/view/first_page_view.dart';
import 'package:tot/common/view/root_tab.dart';
import 'package:tot/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kakao.KakaoSdk.init(nativeAppKey: '65883b79301a6a8e7b88ab503dfc2959');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    _App(),
  );
}

class _App extends StatelessWidget {
  _App({Key? key}) : super(key: key);
  final BookmarkCache x = Get.put(BookmarkCache());
  final AppController c = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(430.0, 932.0),
      builder: (context, child) => FutureBuilder(
        future: c.initialize(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: DefaultLayout(
                child: Center(
                  child: Text("data load fail"),
                ),
              ),
            );
          }
          if (snapshot.hasData) {
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
              resizeToAvoidBottomInset: false,
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
