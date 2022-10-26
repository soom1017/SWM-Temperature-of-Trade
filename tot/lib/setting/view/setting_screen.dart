import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    //   SettingsList(
    //   sections: [
    //     SettingsSection(
    //       title: Text('Common'),
    //       tiles: <SettingsTile>[
    //         SettingsTile.navigation(
    //           leading: Icon(Icons.language),
    //           title: Text('Language'),
    //           value: Text('English'),
    //         ),
    //         SettingsTile.switchTile(
    //           onToggle: (value) {},
    //           initialValue: true,
    //           leading: Icon(Icons.format_paint),
    //           title: Text('Enable custom theme'),
    //         ),
    //       ],
    //     ),
    //   ],
    // );
      Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Setting page"),
          Text(FirebaseAuth.instance.currentUser!.email.toString()),
          Text(FirebaseAuth.instance.currentUser!.displayName.toString()),
          Text(FirebaseAuth.instance.currentUser!.metadata.toString()),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // 카카오 로그아웃
              // UserApi.instance.unlink();
            },
            child: Text("logout"),
          ),
        ],
      ),
    );
  }
}
