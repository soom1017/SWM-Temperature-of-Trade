import 'package:flutter/material.dart';
import 'package:tot/common/const/colors.dart';

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
      appBar: isExtraPage ? renderExtraPageAppBar() : renderAppBar() ,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 62,
      title: const Text('ToT',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500, color: PRIMARY_COLOR)),
      // centerTitle: true,
      leading: Icon(Icons.cake, color: PRIMARY_COLOR,),
      // foregroundColor: Colors.black,
      elevation: 0,
      actions: const [
        IconButton(
          onPressed: null,
          icon: Icon(
            Icons.search_outlined,
            color: PRIMARY_COLOR,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: null,
          icon: Icon(
            Icons.notifications_outlined,
            color: PRIMARY_COLOR,
            size: 30,
          ),
        ),
      ],
    );
  }

  AppBar renderExtraPageAppBar() {
    return AppBar(
      title: Text(pageName!, style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600)),
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 5,
    );
  }
}
