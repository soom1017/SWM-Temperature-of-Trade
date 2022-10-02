// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final app = AppState(false, null);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    // Firebase.initializeApp().whenComplete(() => null);
  }

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
        children: <Widget>[
          Text('id'),
          Text('pass'),
          ElevatedButton(
            child: Text('login'),
            onPressed: () {
              _signIn();
            },
          )
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

  Future<String> _signIn() async {
    setState(() => app.loading = true);
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;
    print(user);

    setState(() {
      app.loading = false;
      app.user = user!;
    });

    return 'success';
  }

  void _signOut() async {
    await googleSignIn.signOut();
    // await _auth.signOut();
    setState(() {
      app.user = null;
    });
  }
}

class AppState {
  bool loading;
  User? user;
  AppState(this.loading, this.user);
}
