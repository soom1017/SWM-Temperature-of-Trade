import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tot/common/layout/default_layout.dart';
import 'package:tot/common/root_tab.dart';
import 'package:tot/login/view/login_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(
    _App(),
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot){
        print("main");
        if(snapshot.hasError){
          return MaterialApp(debugShowCheckedModeBanner: false, home: DefaultLayout(child: Center(
            child: Text("Firebase load fail"),
          )));
        }
        if(snapshot.connectionState == ConnectionState.done) {
          return _AuthApp();
        }
        // 로딩 페이지
        return MaterialApp(debugShowCheckedModeBanner: false, home: DefaultLayout(child: CircularProgressIndicator(),));
      }
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
          print("authApp");
          if(!snapshot.hasData){
            print("no data in authApp");
            return MaterialApp(debugShowCheckedModeBanner: false, home: DefaultLayout(child: LoginScreen(),));
          }else{
            print("has data in authApp");
            return MaterialApp(debugShowCheckedModeBanner: false, home: RootTab());
          }
        },
    );
  }
}
