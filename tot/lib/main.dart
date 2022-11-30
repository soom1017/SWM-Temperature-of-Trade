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

class _App extends StatefulWidget{
  _App({Key? key}) : super(key: key);

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> with WidgetsBindingObserver{
  final BookmarkCache x = Get.put(BookmarkCache());
  final AppController c = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      // 앱이 표시되고 사용자 입력에 응답합니다.
      // 주의! 최초 앱 실행때는 해당 이벤트가 발생하지 않습니다.
        print("resumed");
        break;
      case AppLifecycleState.inactive:
      // 앱이 비활성화 상태이고 사용자의 입력을 받지 않습니다.
      // ios에서는 포 그라운드 비활성 상태에서 실행되는 앱 또는 Flutter 호스트 뷰에 해당합니다.
      // 안드로이드에서는 화면 분할 앱, 전화 통화, PIP 앱, 시스템 대화 상자 또는 다른 창과 같은 다른 활동이 집중되면 앱이이 상태로 전환됩니다.
      // inactive가 발생되고 얼마후 pasued가 발생합니다.
        print("inactive");
        break;
      case AppLifecycleState.paused:
      // 앱이 현재 사용자에게 보이지 않고, 사용자의 입력을 받지 않으며, 백그라운드에서 동작 중입니다.
      // 안드로이드의 onPause()와 동일합니다.
      // 응용 프로그램이 이 상태에 있으면 엔진은 Window.onBeginFrame 및 Window.onDrawFrame 콜백을 호출하지 않습니다.
        print("paused");
        break;
      case AppLifecycleState.detached:
      // 응용 프로그램은 여전히 flutter 엔진에서 호스팅되지만 "호스트 View"에서 분리됩니다.
      // 앱이 이 상태에 있으면 엔진이 "View"없이 실행됩니다.
      // 엔진이 처음 초기화 될 때 "View" 연결 진행 중이거나 네비게이터 팝으로 인해 "View"가 파괴 된 후 일 수 있습니다.
        print("detached");
        break;
    }
  }

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
            if (Get.currentRoute == "/NotifyView") {
              Get.off(() => NotifyView(), preventDuplicates: false);
            } else {
              Get.to(() => NotifyView());
            }
          }
          return true;
        }),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: DefaultLayout(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "데이터 로딩에 실패했습니다.\n인터넷 연결상태를 확인해주세요",
                        style: TextStyle(
                            fontSize: 38.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 100.h,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text("새로고침")),
                    ],
                  ),
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
