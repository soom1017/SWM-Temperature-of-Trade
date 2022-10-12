import 'package:flutter/material.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/custom_icons_icons.dart';
import 'package:tot/common/view/root_tab.dart';
import 'package:tot/common/view/notify_view.dart';
import 'package:tot/common/view/search_view.dart';
import 'package:tot/home/view/home_screen.dart';
import 'package:transition/transition.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;
  final bool isExtraPage;
  final String? pageName;

  const DefaultLayout({
    required this.child,
    this.bottomNavigationBar,
    Key? key,
    this.isExtraPage = false,
    this.pageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BG_COLOR,
      appBar:
          isExtraPage ? renderExtraPageAppBar(context) : renderAppBar(context),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar renderAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // toolbarHeight: 62,
      title: const Text('ToT',
          style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w500,
              color: PRIMARY_COLOR,)),
      // centerTitle: true,
      leadingWidth: 30,
      leading: const Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
        child: Icon(CustomIcons.icon1, color: KEYWORD_BG_COLOR, size: 30,),
      ),
      // foregroundColor: Colors.black,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            routeToSearchPage(context);
          },
          icon: Icon(
            Icons.search_outlined,
            color: PRIMARY_COLOR,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () {
            routeToNotifyPage(context);
          },
          icon: Icon(
            Icons.notifications_outlined,
            color: PRIMARY_COLOR,
            size: 30,
          ),
        ),
      ],
    );
  }

  AppBar renderExtraPageAppBar(BuildContext context) {
    return AppBar(
      title: Text(pageName!,
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600)),
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
            size: 30,
          ),
        ),
      ],
    );
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