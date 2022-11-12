import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/AppController.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/view/first_page_view.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool ch = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    final preFcmToken = await AppController.storage.read(key: "fcmToken");
    final fcmToken = await FirebaseMessaging.instance.getToken();
    setState(() {
      if (preFcmToken == null || preFcmToken != fcmToken) {
        ch = false;
      } else {
        ch = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
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
              onToggle: (value) async {
                try {
                  if (value) {
                    final fcmToken =
                        await FirebaseMessaging.instance.getToken();
                    await AppController.storage
                        .write(key: "fcmToken", value: fcmToken);
                    await API.updateNotificationSetting(fcmToken);
                  } else {
                    await AppController.storage
                        .write(key: "fcmToken", value: "");
                    await AppController.storage
                        .write(key: "notify", value: "[]]");
                    await API.updateNotificationSetting("");
                  }
                } catch (e) {
                  print(e);
                }
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
              title: Text(!FirebaseAuth.instance.currentUser!.isAnonymous
                  ? '로그아웃'
                  : '로그인'),
              onPressed: (value) async {
                if (FirebaseAuth.instance.currentUser!.isAnonymous) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => FirstPageView()),
                      (route) => false);
                } else {
                  pd.show(max: 100, msg: '로그아웃 하는 중...');
                  pd.update(value: 25);
                  await FirebaseAuth.instance.signOut();
                  pd.update(value: 50);
                  await FirebaseAuth.instance.signInAnonymously();
                  pd.update(value: 75);
                  await API.changeDioToken();
                  pd.update(value: 100);
                  userBookmark = [];
                  userFilterKey = {};
                  pd.close();
                  Future.delayed(
                      Duration.zero,
                      () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => FirstPageView()),
                          (route) => false));
                }
              },
            ),
            if (!FirebaseAuth.instance.currentUser!.isAnonymous)
              SettingsTile.navigation(
                title: Text('회원탈퇴'),
                onPressed: (_) async {
                  Future.delayed(
                    Duration.zero,
                        () => showPlatformDialog(
                      context: context,
                      builder: (_) => PlatformAlertDialog(
                        title: Text(
                          '정말로 회원탈퇴 하시겠습니까?',
                          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
                        ),
                        content: Text(
                          '탈퇴하시면 모든 데이터는 복구가 불가능합니다.',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        actions: <Widget>[
                          PlatformDialogAction(
                            child: PlatformText("네"),
                            onPressed: () async {
                              await API.deleteUser();
                              await FirebaseAuth.instance.signOut();
                              await FirebaseAuth.instance.signInAnonymously();
                              await API.changeDioToken();
                              Future.delayed(
                                  Duration.zero,
                                      () => Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (_) => FirstPageView()),
                                          (route) => false));
                            },
                          ),
                          PlatformDialogAction(
                            child: PlatformText("아니오"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}
