// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tot/common/data/API.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _loading();
    return _logIn();
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
          Platform.isIOS ? ElevatedButton(
            child: Text('apple login'),
            onPressed: () {
              _signInApple();
            },
          ) : SizedBox(),
          ElevatedButton(
            child: Text('kakao login'),
            onPressed: () {
              _signInKakao();
            },
          ),
          // ElevatedButton(
          //   child: Text('naver login'),
          //   onPressed: () {
          //     _signInNaver();
          //   },
          // ),
        ],
      ),
    );
  }

  Future<UserCredential> _signInGoogle() async {
    setState(() => _isLoading = true);
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    final authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

    setState(() => _isLoading = false);
    return authResult;
  }

  Future<UserCredential> _signInFacebook() async {
    setState(() => _isLoading = true);
    final FacebookLoginResult result = await FacebookLogin().logIn();
    final AuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    final authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(credential.toString());
    setState(() => _isLoading = false);
    return authResult;
  }

  Future<UserCredential> _signInApple() async {
    setState(() => _isLoading = true);
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

    setState(() => _isLoading = false);
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  Future<String?> createCustomToken(Map<String, dynamic> user) async{
    try {
      final String url = '/users/auth/kakao';
      // print(user.toString());
      print("create custom token start");
      // final customTokenResponse = await API.dio.post(url, queryParameters: user);
      final customTokenResponse = await API.dio.post(url, data: user);
      print("create custom token end");
      return customTokenResponse.data;
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<UserCredential?> _signInKakao() async {
    setState(() => _isLoading = true);
    final isInstalled = await kakao.isKakaoTalkInstalled();
    var token;
    if(isInstalled){
      final data = await kakao.UserApi.instance.loginWithKakaoTalk();
      token = data.accessToken;
    }else{
      final data = await kakao.UserApi.instance.loginWithKakaoAccount();
      token = data.accessToken;
    }

    final user = await kakao.UserApi.instance.me();
    print("customToken start");
    final customToken = await createCustomToken({
      'uid' : user!.id.toString(),
      // 'name' : user!.kakaoAccount!.name,
      'access_token': token.toString(),
    });
    print("customToken end");
    setState(() => _isLoading = false);
    print("temp start");
    final temp = await FirebaseAuth.instance.signInWithCustomToken(customToken!);
    print("temp end");
    print("idToken start");
    final idToken = await FirebaseMessaging.instance.getToken();
    print("idToken end");
    // print(temp);
    print(idToken);
    return temp;
  }

  void _signInNaver() {}
}