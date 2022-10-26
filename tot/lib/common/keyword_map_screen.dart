import 'package:flutter/material.dart';
import 'package:tot/common/layout/default_layout.dart';

class KeywordMapScreen extends StatelessWidget {
  final String keyword;
  const KeywordMapScreen({required this.keyword, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        pageName: "키워드 지도", isExtraPage: true, child: Text(keyword));
  }
}
