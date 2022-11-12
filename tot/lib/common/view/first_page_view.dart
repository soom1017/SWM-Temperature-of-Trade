import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/AppController.dart';
import 'package:tot/common/view/root_tab.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class FirstPageView extends StatelessWidget {
  FirstPageView({Key? key}) : super(key: key);
  final AppController c = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250.h,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: Container(
              width: 110.w,
              child: Image.asset('assets/image/asset5.png'),
            ),
          ),
          SizedBox(height: 100.h),
          Text(
            '다른 계정으로 로그인',
            style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                color: PRIMARY_COLOR),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _RoundedButton(
                    imageSrc: 'assets/image/facebook.png',
                    press: () async {
                      await _signInFacebook(context);
                      _naviToRootTab();
                    }),
                if (Platform.isIOS)
                  _RoundedButton(
                      imageSrc: 'assets/image/apple.png',
                      press: () async {
                        await _signInApple(context);
                        _naviToRootTab();
                      }),
                _RoundedButton(
                    imageSrc: 'assets/image/google.png',
                    press: () async {
                      await _signInGoogle(context);
                      _naviToRootTab();
                    }),
                _RoundedButton(
                    imageSrc: 'assets/image/kakao.png',
                    press: () async {
                      await _signInKakao(context);
                      _naviToRootTab();
                    }),
              ],
            ),
          ),
          Text(
            "또는",
            style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                color: PRIMARY_COLOR),
          ),
          SizedBox(
            height: 20.h,
          ),
          GestureDetector(
            onTap: () {
              _naviToRootTab();
            },
            child: Text(
              "게스트로 로그인",
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                  color: PRIMARY_COLOR),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signInGoogle(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    pd.show(max: 100, msg: '로그인 하는 중...');
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    pd.update(value: 20);
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    pd.update(value: 40);
    final _token = await user.user!.getIdToken();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    pd.update(value: 60);
    await _authUser({
      'isKakao': false,
      'access_token': _token.toString(),
      'fcm_token': fcmToken,
      'uid': user.user!.uid,
    });
    pd.update(value: 80);
    await c.initialize();
    pd.update(value: 100);
    pd.close();
  }

  Future<void> _signInFacebook(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    final FacebookLoginResult result = await FacebookLogin().logIn();
    pd.show(max: 100, msg: '로그인 하는 중...');
    final AuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    pd.update(value: 20);
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    pd.update(value: 40);
    final _token = await user.user!.getIdToken();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    pd.update(value: 60);
    await _authUser({
      'isKakao': false,
      'access_token': _token.toString(),
      'fcm_token': fcmToken,
      'uid': user.user!.uid,
    });
    pd.update(value: 80);
    await c.initialize();
    pd.update(value: 100);
    pd.close();
  }

  Future<void> _signInApple(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    pd.show(max: 100, msg: '로그인 하는 중...');
    final credential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    pd.update(value: 20);
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    pd.update(value: 40);
    final _token = await user.user!.getIdToken();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    pd.update(value: 60);
    await _authUser({
      'access_token': _token.toString(),
      'fcm_token': fcmToken,
      'isKakao': false,
      'uid': user.user!.uid,
    });
    pd.update(value: 80);
    await c.initialize();
    pd.update(value: 100);
    pd.close();
  }

  Future<void> _signInKakao(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    final isInstalled = await kakao.isKakaoTalkInstalled();
    late String token;
    if (isInstalled) {
      final temp = await kakao.UserApi.instance.loginWithKakaoTalk();
      token = temp.accessToken;
    } else {
      final temp = await kakao.UserApi.instance.loginWithKakaoAccount();
      token = temp.accessToken;
    }
    pd.show(max: 100, msg: '로그인 하는 중...');
    final user = await kakao.UserApi.instance.me();
    pd.update(value: 20);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    pd.update(value: 40);

    final customToken = await _authUser({
      'isKakao': true,
      'uid': user.id.toString(),
      'access_token': token.toString(),
      'fcm_token': fcmToken,
    });
    pd.update(value: 60);
    await FirebaseAuth.instance.signInWithCustomToken(customToken!);
    pd.update(value: 80);
    await c.initialize();
    pd.update(value: 100);
    pd.close();
  }

  Future<String?> _authUser(Map<String, dynamic> user) async {
    try {
      await AppController.storage
          .write(key: "fcmToken", value: user["fcm_token"]);
      final String url = '/users/auth';
      final customTokenResponse = await API.dio.post(url, data: user);
      return customTokenResponse.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _naviToRootTab() {
    Future.delayed(Duration.zero, () => Get.offAll(RootTab()));
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
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
        child: Container(
          width: 65.w,
          height: 65.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(imageSrc),
        ),
      ),
    );
  }
}
