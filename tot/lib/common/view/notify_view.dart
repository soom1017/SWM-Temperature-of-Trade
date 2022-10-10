import 'package:flutter/material.dart';

import '../layout/default_layout.dart';

class NotifyView extends StatelessWidget {
  const NotifyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        isExtraPage: true,
        pageName: "알림",
        child: Container());
  }
}
