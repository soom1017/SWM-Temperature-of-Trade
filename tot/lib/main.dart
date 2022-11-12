import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:tot/common/data/AppController.dart';
import 'package:tot/common/data/BookmarkCache.dart';
import 'package:tot/common/layout/default_layout.dart';
import 'package:tot/common/view/first_page_view.dart';
import 'package:tot/common/view/notify_view.dart';
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
        future: c.initialize().then((_) async {
          // 종료 상태에서 알림 터치시
          RemoteMessage? initialMessage =
              await FirebaseMessaging.instance.getInitialMessage();
          if (initialMessage != null) {
            final _data = json.decode(initialMessage.data.toString());
            print("init : " + _data.toString());

            final List<dynamic> _notifyList = json.decode(
                await AppController.storage.read(key: "notify") ?? "[]");
            _notifyList.insert(0, {
              "id": _data["id"],
              "title": _data["title"],
              "time": _data["time"],
            });

            await AppController.storage
                .write(key: "notify", value: json.encode(_notifyList));
            Get.to(() => NotifyView());
          }
          return true;
        }),
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
            return GetMaterialApp(
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
