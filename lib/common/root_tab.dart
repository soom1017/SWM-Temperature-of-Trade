import 'package:flutter/material.dart';
import 'package:tot/bookmark/view/bookmark_screen.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/layout/default_layout.dart';
import 'package:tot/home/view/home_screen.dart';
import 'package:tot/mypage/view/mypage_screen.dart';
import 'package:tot/login/view/login_screen.dart';
import 'package:tot/setting/view/setting_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab>
    with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }  

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener(){
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: KEYWORD_BG_COLOR,
        unselectedItemColor: SMALL_FONT_COLOR,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 30,),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity, size: 30,),
            label: '마이페이지',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border, size: 30,),
            label: '북마크',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30,),
            label: '설정',
          )
        ],
      ),
      child:TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          HomeScreen(),
          MypageScreen(),
          BookmarkScreen(),
          SettingScreen(),
        ],
      ),
    );
  }
}
