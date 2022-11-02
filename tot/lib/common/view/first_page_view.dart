import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/view/root_tab.dart';
import 'package:tot/main.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class FirstPageView extends StatelessWidget {
  const FirstPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 110,
              child: Image.asset('assets/image/asset6.png'),
            ),
          ),
          SizedBox(height: 100),
          Text(
            '다른 계정으로 로그인',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: PRIMARY_COLOR),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _RoundedButton(
                    imageSrc: 'assets/image/facebook.png',
                    press: () async {
                      await _signInFacebook();
                      _naviToRootTab(context);
                    }),
                if (Platform.isIOS)
                  _RoundedButton(
                      imageSrc: 'assets/image/apple.png',
                      press: () async {
                        await _signInApple();
                        _naviToRootTab(context);
                      }),
                _RoundedButton(
                    imageSrc: 'assets/image/google.png',
                    press: () async {
                      await _signInGoogle();
                      _naviToRootTab(context);
                    }),
                _RoundedButton(
                    imageSrc: 'assets/image/kakao.png',
                    press: () async {
                      await _signInKakao();
                      _naviToRootTab(context);
                    }),
              ],
            ),
          ),
          Text(
            "또는",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: PRIMARY_COLOR),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              _naviToRootTab(context);
            },
            child: Text(
              "게스트로 로그인",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: PRIMARY_COLOR),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signInGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    await _authUser({
      'uid': user.user!.uid.toString(),
      'access_token':
          FirebaseAuth.instance.currentUser!.getIdToken().toString(),
    });
  }

  Future<void> _signInFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    final AuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    await _authUser({
      'uid': user.user!.uid.toString(),
      'access_token':
          FirebaseAuth.instance.currentUser!.getIdToken().toString(),
    });
  }

  Future<void> _signInApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final credential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    await _authUser({
      'access_token':
          FirebaseAuth.instance.currentUser!.getIdToken().toString(),
    });
    await API.changeDioToken();
    await getBookmarkByLoad();
  }

  Future<void> _signInKakao() async {
    final isInstalled = await kakao.isKakaoTalkInstalled();
    late String token;
    if (isInstalled) {
      final temp = await kakao.UserApi.instance.loginWithKakaoTalk();
      token = temp.accessToken;
    } else {
      final temp = await kakao.UserApi.instance.loginWithKakaoAccount();
      token = temp.accessToken;
    }
    print(FirebaseAuth.instance.currentUser);
    final user = await kakao.UserApi.instance.me();
    final customToken = await _authUser({
      'isKakao': true,
      'uid': user.id.toString(),
      'access_token': token.toString(),
    });

    await FirebaseAuth.instance.signInWithCustomToken(customToken!);
    await API.changeDioToken();
    await getBookmarkByLoad();
  }

  Future<String?> _authUser(Map<String, dynamic> user) async {
    try {
      final String url = '/users/auth';
      final customTokenResponse = await API.dio.post(url, data: user);
      return customTokenResponse.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _naviToRootTab(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RootTab(),
        ));
  }
}

class _RoundedButton extends StatelessWidget {
  final String imageSrc;
  final VoidCallback press;

  const _RoundedButton({Key? key, required this.imageSrc, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(imageSrc),
        ),
      ),
    );
  }
}
