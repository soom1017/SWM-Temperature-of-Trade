import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:tot/common/layout/default_layout.dart';
import 'package:tot/common/view/root_tab.dart';
import 'package:tot/firebase_options.dart';
import 'package:tot/graph.dart';
import 'package:tot/login/view/login_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  kakao.KakaoSdk.init(nativeAppKey: '65883b79301a6a8e7b88ab503dfc2959');
  runApp(
    _App(),
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
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
          return _AuthApp();
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

class _AuthApp extends StatelessWidget {
  const _AuthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DefaultLayout(
              child: LoginScreen(),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: RootTab(),
          );
        }
      },
    );
  }
}
