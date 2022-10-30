import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/layout/default_layout.dart';
import 'package:tot/login/view/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool ch = false;

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      brightness: Brightness.light,
      lightTheme: SettingsThemeData(
        dividerColor: Colors.grey,
        settingsListBackground: Colors.white,
        settingsSectionBackground: HOME_BG_COLOR,
      ),
      sections: [
        SettingsSection(
          title: Text('사용설정'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              description: Text("관심 설정한 키워드와 종목에 관한 뉴스가 올라올 때 알려드립니다."),
              onToggle: (value) {
                setState(() {
                  ch = value;
                });
              },
              initialValue: ch,
              title: Text('푸시알림'),
            ),
          ],
        ),
        SettingsSection(
          title: Text('기타'),
          tiles: <SettingsTile>[
            SettingsTile(
              title: Text('버전정보'),
              trailing: Text('1.0.0'),
              description: Text('앱이 최신버전입니다.'),
            ),
            SettingsTile.navigation(
              title: Text('로그아웃'),
              onPressed: (value) async {
                await FirebaseAuth.instance.signOut();
                await FirebaseAuth.instance.signInAnonymously();
                await API.changeDioToken();
                userBookmark = [];
                var snackbar = SnackBar(
                  content: Text("로그아웃 되었습니다."),
                  duration: Duration(milliseconds: 1500),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              },
            ),
          ],
        ),
      ],
    );
    // return StreamBuilder(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
    //     if (!snapshot.hasData) {
    //       return _SettingView();
    //     } else {
    //       return _SettingView();
    //     }
    //   },
    // );
  }
}

// class _SettingView extends StatelessWidget {
//   const _SettingView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("Setting page"),
//           if (FirebaseAuth.instance.currentUser != null)
//             Text(
//                 "name : ${FirebaseAuth.instance.currentUser!.displayName.toString()}"),
//           if (FirebaseAuth.instance.currentUser != null)
//             Text(
//                 "isAnonymous : ${FirebaseAuth.instance.currentUser!.isAnonymous.toString()}"),
//           if (FirebaseAuth.instance.currentUser != null)
//             ElevatedButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//                 await FirebaseAuth.instance.signInAnonymously();
//                 await API.changeDioToken();
//                 userBookmark = [];
//               },
//               child: Text("logout"),
//             ),
//           if (FirebaseAuth.instance.currentUser == null)
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => DefaultLayout(
//                               child: LoginScreen(),
//                               isExtraPage: true,
//                               pageName: "로그인",
//                             )));
//               },
//               child: Text("login"),
//             ),
//         ],
//       ),
//     );
//   }
// }
