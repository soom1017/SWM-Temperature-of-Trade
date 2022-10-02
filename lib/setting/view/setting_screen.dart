import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final app = AppState(true, '');

  @override
  void initState() {
    super.initState();
    _delay();
  }

  @override
  Widget build(BuildContext context) {
    if (app.loading) return _loading();
    if (app.user.isEmpty) return _signIn();
    return _main();
  }

  _delay() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() => app.loading = false);
    });
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _signIn() {
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
              setState(() {
                app.loading = true;
                app.user = 'my name';
                _delay();
              });
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
          setState(() {
            app.user = '';
            app.loading = true;
            _delay();
          });
        },
      ),
    );
  }
}

class AppState {
  bool loading;
  FirebaseUser user;
  AppState(this.loading, this.user);
}
