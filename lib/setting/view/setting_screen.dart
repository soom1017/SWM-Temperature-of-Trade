// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:tot/common/const/values.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final app = AppState(false, null);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookSignIn = FacebookLogin();
  LoginPlatform _loginPlatform = LoginPlatform.none;

  @override
  Widget build(BuildContext context) {
    if (app.loading) return _loading();
    if (app.user == null) return _logIn();
    return _main();
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _logIn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text('google login'),
            onPressed: () {
              _signInGoogle();
            },
          ),
          ElevatedButton(
            child: Text('facebook login'),
            onPressed: () {
              _signInFacebook();
            },
          ),
        ],
      ),
    );
  }

  Widget _main() {
    return Center(
      child: IconButton(
        icon: Icon(Icons.account_circle),
        onPressed: () {
          _signOut();
        },
      ),
    );
  }

  Future<String> _signInGoogle() async {
    setState(() => app.loading = true);
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user!;
    print(user);

    setState(() {
      _loginPlatform = LoginPlatform.google;
      app.loading = false;
      app.user = user;
    });

    return 'success';
  }

  Future<String> _signInFacebook() async {
    setState(() => app.loading = true);
    final FacebookLoginResult result = await facebookSignIn.logIn();
    final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user!;

    print(user);

    setState(() {
      _loginPlatform = LoginPlatform.facebook;
      app.loading = false;
      app.user = user;
    });

    return 'success';
  }

  void _signOut() async {
    await _auth.signOut();
    switch (_loginPlatform){
      case LoginPlatform.google:
        await googleSignIn.signOut();
        break;
      case LoginPlatform.facebook:
        await facebookSignIn.logOut();
        break;
      case LoginPlatform.apple:
        break;
      case LoginPlatform.kakao:
        break;
      case LoginPlatform.naver:
        break;
      case LoginPlatform.none:
        break;
    }
    setState(() {
      _loginPlatform = LoginPlatform.none;
      app.user = null;
    });
  }
}

class AppState {
  bool loading;
  User? user;
  AppState(this.loading, this.user);
}
