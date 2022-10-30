import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/layout/default_layout.dart';

import '../../common/component/news_tile.dart';
import '../../common/const/colors.dart';
import '../../common/const/padding.dart';

class HomeHotNewScreen extends StatefulWidget {
  final bool isHot;

  const HomeHotNewScreen({required this.isHot, Key? key}) : super(key: key);

  @override
  State<HomeHotNewScreen> createState() => _HomeHotNewScreenState();
}

class _HomeHotNewScreenState extends State<HomeHotNewScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      pageName: widget.isHot ? "HOT" : "NEW",
      isExtraPage: true,
      child: FutureBuilder(
        future: widget.isHot ? API.getNewsListHot() : API.getNewsListNew(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData == false)
            return Center(child:CircularProgressIndicator());
          return Container(
            color: NEWSTAB_BG_COLOR,
            padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
            child: SlidableAutoCloseBehavior(
              child: ListView.separated(
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          widget.isHot ? "많은 사용자가 본 뉴스" : "새롭게 업데이트된 뉴스",
                          style: TextStyle(
                              fontSize: 30,
                              color: PRIMARY_COLOR,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  }
                  // return _newsTileList[i - 1];
                  return NewsTile.fromData(snapshot.data[i - 1]);
                },
                separatorBuilder: (context, i) {
                  if (i == 0) return SizedBox.shrink();
                  return const Divider(
                    thickness: 1.5,
                  );
                },
                // itemCount: _newsTileList.length,
                itemCount: snapshot.data.length,
              ),
            ),
          );
        },
      ),
    );
  }
}
