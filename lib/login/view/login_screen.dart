// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
          // ElevatedButton(
          //   child: Text('kakao login'),
          //   onPressed: () {
          //     _signInKakao();
          //   },
          // ),
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

  void _signInKakao() {}
  void _signInNaver() {}
}
