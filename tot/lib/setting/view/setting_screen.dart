import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/layout/default_layout.dart';
import 'package:tot/login/view/login_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (!snapshot.hasData) {
          return _SettingView();
        } else {
          return _SettingView();
        }
      },
    );
  }
}

class _SettingView extends StatelessWidget {
  const _SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Setting page"),
          if (FirebaseAuth.instance.currentUser != null)
            Text(
                "name : ${FirebaseAuth.instance.currentUser!.displayName.toString()}"),
          if (FirebaseAuth.instance.currentUser != null)
            Text(
                "isAnonymous : ${FirebaseAuth.instance.currentUser!.isAnonymous.toString()}"),
          if (FirebaseAuth.instance.currentUser != null)
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await FirebaseAuth.instance.signInAnonymously();
                await API.changeDioToken();
                userBookmark = [];
              },
              child: Text("logout"),
            ),
          if (FirebaseAuth.instance.currentUser == null)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DefaultLayout(
                              child: LoginScreen(),
                              isExtraPage: true,
                              pageName: "로그인",
                            )));
              },
              child: Text("login"),
            ),
        ],
      ),
    );
  }
}

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
