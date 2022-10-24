// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
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
          Platform.isIOS
              ? ElevatedButton(
                  child: Text('apple login'),
                  onPressed: () {
                    _signInApple();
                  },
                )
              : SizedBox(),
          ElevatedButton(
            child: Text('kakao login'),
            onPressed: () {
              _signInKakao();
            },
          ),
          ElevatedButton(
            child: Text('뒤로가기'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _signInGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pop(context);
  }

  void _signInFacebook() async {
    final FacebookLoginResult result = await FacebookLogin().logIn();
    final AuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pop(context);
  }

  void _signInApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    Navigator.pop(context);
  }

  Future<String?> createCustomToken(Map<String, dynamic> user) async {
    try {
      final String url = '/users/auth/kakao';
      final customTokenResponse = await API.dio.post(url, data: user);
      return customTokenResponse.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _signInKakao() async {
    final isInstalled = await kakao.isKakaoTalkInstalled();
    late String token;
    if (isInstalled) {
      final temp = await kakao.UserApi.instance
          .loginWithKakaoTalk();
      token = temp.accessToken;
    } else {
      final temp = await kakao.UserApi.instance
          .loginWithKakaoAccount();
      token = temp.accessToken;
    }

    final user = await kakao.UserApi.instance.me();
    final customToken = await createCustomToken({
      'uid': user.id.toString(),
      // 'displayName' : user!.kakaoAccount!.name,
      'access_token': token.toString(),
    });

    await FirebaseAuth.instance.signInWithCustomToken(customToken!);
    await API.changeDioToken();
    await getBookmarkByLoad();
    Navigator.pop(context);
  }

  void _signInNaver() {}
}
