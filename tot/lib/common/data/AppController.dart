import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/BookmarkCache.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/firebase_options.dart';

class AppController extends GetxController {
  static AppController get to => Get.find<AppController>();

  Future<bool> initialize() async {
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
    return true;
  }
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
  print(temp);
  userFilterKey = temp;
}