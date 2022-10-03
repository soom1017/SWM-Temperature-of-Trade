import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Setting page"),
          ElevatedButton(
            onPressed: FirebaseAuth.instance.signOut,
            child: Text("logout"),
          ),
        ],
      ),
    );
  }
}
