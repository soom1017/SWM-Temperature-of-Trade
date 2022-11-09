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
import 'package:tot/common/data/BookmarkCache.dart';
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
    GetMaterialApp(
      home: _App(),
    ),
  );
}

Future<FirebaseApp> _load() async {
  var temp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationSettings authStatus =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage rm) {
      print(rm.toString());
    },
  );

  const AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    importance: Importance.max,
    description: 'This channel is used for important notifications.',
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);

  // if (authStatus.authorizationStatus == AuthorizationStatus.authorized) {
  //   FirebaseMessaging.instance.isSupported()
  //
  // }
  //
  // if (Platform.isAndroid) {
  //   final fcmToken = await FirebaseMessaging.instance.getToken();
  //   print(fcmToken);
  // } else if (Platform.isIOS) {
  //   final fcmToken = await FirebaseMessaging.instance.getToken();
  //   print(fcmToken);
  // }

  if (FirebaseAuth.instance.currentUser != null &&
      !FirebaseAuth.instance.currentUser!.isAnonymous) {
    await API.changeDioToken();
    await BookmarkCache.to.loadBookmark();
    await getBookmarkByLoad();
    await getKeywordRankByLoad();
    await getFilterKeywordByLoad();
    await getUsersFavoritesByLoad();
    print("is Anonymous? : ${FirebaseAuth.instance.currentUser!.isAnonymous}");
  }
  if (FirebaseAuth.instance.currentUser == null ||
      FirebaseAuth.instance.currentUser!.isAnonymous) {
    await FirebaseAuth.instance.signInAnonymously();
    await API.changeDioToken();
    await getKeywordRankByLoad();
    await getFilterKeywordByLoad();
    print("is Anonymous? : ${FirebaseAuth.instance.currentUser!.isAnonymous}");
  }
  return temp;
}

Future<void> getBookmarkByLoad() async {
  final bookmark = await tokenCheck(() => API.getUserBookmark());
  if (bookmark != null) {
    userBookmark = bookmark.map((e) => e.id).toList();
  } else {
    userBookmark = [];
  }
}

Future<void> getKeywordRankByLoad() async {
  final temp = List<String>.from(await tokenCheck(() => API.getKeywordRank()));
  keywordListRank.addAll(temp!);
}

Future<void> getFilterKeywordByLoad() async {
  final temp = await tokenCheck(() => API.getFilterKeyword());
  filterKeyword = temp;
}

Future<void> getUsersFavoritesByLoad() async {
  final temp = await tokenCheck(() => API.getUserFavorites());
  userFilterKey = temp;
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final BookmarkCache x = Get.put(BookmarkCache());
    return ScreenUtilInit(
      designSize: Size(430.0, 932.0),
      builder: (context, child) => FutureBuilder(
        future: _load(),
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
