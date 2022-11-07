import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tot/bookmark/view/bookmark_screen.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/layout/default_layout.dart';
import 'package:tot/home/view/home_screen.dart';
import 'package:tot/myfilter/view/myfilter_screen.dart';
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
        selectedFontSize: 11.sp,
        unselectedFontSize: 11.sp,
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: index == 0 ? Icon(Icons.home, size: 30.sp) : Icon(Icons.home_outlined, size: 30.sp,),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: index == 1 ? Icon(Icons.filter_alt, size:30.sp,) : Icon(Icons.filter_alt_outlined, size: 30.sp,),
            label: '마이필터',
          ),
          BottomNavigationBarItem(
            icon: index == 2 ? Icon(Icons.bookmark, size:30.sp,) : Icon(Icons.bookmark_border, size: 30.sp,),
            label: '북마크',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30.sp,),
            label: '설정',
          )
        ],
      ),
      child:TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          HomeScreen(),
          MyfilterScreen(),
          BookmarkScreen(),
          SettingScreen(),
        ],
      ),
    );
  }
}
