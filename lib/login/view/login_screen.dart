// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tot/common/const/values.dart';

String generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    print("loginScreen");
    if (_isLoading) return _loading();
    // if (FirebaseAuth.instance.currentUser == null) return _logIn();
    return _logIn(); //asdfasdfasdfas
  }

  Widget _loading() {
    print("loading in loginScreen");
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _logIn() {
    print("_login in loginScreen");
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
}
