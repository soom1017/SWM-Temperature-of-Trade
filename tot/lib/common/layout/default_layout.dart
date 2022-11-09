import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/custom_icons_icons.dart';
import 'package:tot/common/view/root_tab.dart';
import 'package:tot/common/view/notify_view.dart';
import 'package:tot/common/view/search_view.dart';
import 'package:tot/home/view/home_screen.dart';
import 'package:transition/transition.dart';
import 'package:tot/common/const/tot_custom_icons_icons.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFDFEDFA),
    );
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;
  final bool isExtraPage;
  final bool isDetailPage;
  final String? pageName;

  const DefaultLayout({
    required this.child,
    this.bottomNavigationBar,
    Key? key,
    this.isExtraPage = false,
    this.isDetailPage = false,
    this.pageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BG_COLOR,
      appBar: conditionalAppBar(isExtraPage, isDetailPage, context),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar renderAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // toolbarHeight: 62,
      title: Text(
        'ToT',
        style: TextStyle(
          fontSize: 32.0.sp,
          fontWeight: FontWeight.w500,
          color: PRIMARY_COLOR,
        ),
      ),
      // centerTitle: true,
      leadingWidth: 30.w,
      leading: Padding(
        padding: EdgeInsets.fromLTRB(15.w, 0, 10.w, 0),
        child: Icon(
          CustomIcons.icon1,
          color: KEYWORD_BG_COLOR,
          size: 30.sp,
        ),
      ),
      // foregroundColor: Colors.black,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            routeToSearchPage(context);
          },
          icon: Icon(ToTCustomIcons.search, size: 28.sp,color: PRIMARY_COLOR,)
        ),
        IconButton(
          onPressed: () {
            routeToNotifyPage(context);
          },
          icon: Icon(ToTCustomIcons.notify, size: 28.sp,color: PRIMARY_COLOR)
        ),
      ],
    );
  }

  AppBar renderExtraPageAppBar(BuildContext context) {
    return AppBar(
      title: Text(pageName!,
          style: TextStyle(fontSize: 28.0.sp, fontWeight: FontWeight.w600)),
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 5,
      actions: [
        IconButton(
          onPressed: () {
            routeToHomePage(context);
          },
          icon: Icon(
            Icons.home_outlined,
            color: PRIMARY_COLOR,
            size: 30.sp,
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget conditionalAppBar(bool isExtraPage, bool isDetailPage, BuildContext context) {
    if (isExtraPage == true && isDetailPage == true) {
      return EmptyAppBar();
    }
    else if (isExtraPage == true) {
      return renderExtraPageAppBar(context);
    }
    return renderAppBar(context);
  }

  routeToSearchPage(BuildContext context) {
    Navigator.of(context).push(
      Transition(child: SearchView(), transitionEffect: TransitionEffect.FADE),
    );
  }

  routeToNotifyPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NotifyView(),
      ),
    );
  }

  routeToHomePage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RootTab(),
      ),
    );
  }
}
