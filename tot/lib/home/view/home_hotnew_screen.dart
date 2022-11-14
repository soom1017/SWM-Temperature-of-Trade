import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  RefreshController _controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      pageName: widget.isHot ? "HOT" : "NEW",
      // isExtraPage: true,
      child: FutureBuilder(
        future: widget.isHot
            ? tokenCheck(() => API.getNewsListHot())
            : tokenCheck(() => API.getNewsListNew()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false)
            return Center(child: CircularProgressIndicator());
          return Container(
            color: NEWSTAB_BG_COLOR,
            padding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING.w),
            // padding: const EdgeInsets.fromLTRB(HORIZONTAL_PADDING, 0, 5 ,0),
            child: StatefulBuilder(
              builder: (BuildContext context2, setter) {
                if (widget.isHot) {
                  return _refresher(snapshot.data["data"], setter,
                      snapshot.data["update_time"]);
                } else {
                  return _refresher(snapshot.data, setter, null);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _refresher(data, setter, update_time) {
    var t = null;
    if(widget.isHot) {
      t = DateTime.parse(update_time);
    }
    return SlidableAutoCloseBehavior(
      child: SmartRefresher(
        controller: _controller,
        onRefresh: () async {
          var _next = null;
          if (widget.isHot) {
            _next = await tokenCheck(() => API.getNewsListHot());
            update_time = _next["update_time"];
            _next = _next["data"];
          } else {
            _next = await tokenCheck(() => API.getNewsListNew());
          }
          _controller.refreshCompleted();
          data = _next;
          setter(() {});
        },
        onLoading: () async {
          var _next = null;
          if (!data.isEmpty) {
            if (widget.isHot) {
              _next = await tokenCheck(
                  () => API.getNewsListHot(news_id: data.last.id));
              update_time = _next["update_time"];
              _next = _next["data"];
            } else {
              _next = await tokenCheck(
                  () => API.getNewsListNew(news_id: data.last.id));
            }
          }
          _controller.loadComplete();
          if (_next != null) {
            data.addAll(_next!);
          }
          setter(() {});
        },
        enablePullUp: true,
        enablePullDown: true,
        child: ListView.separated(
          itemBuilder: (context, i) {
            if (i == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  if (widget.isHot)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "많은 사용자가 본 뉴스",
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: PRIMARY_COLOR,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          "${t.year}.${t.month.toString().padLeft(2, '0')}.${t.day.toString().padLeft(2, '0')} ${t.hour.toString().padLeft(2, '0')}:${t.minute} 에 업데이트 되었습니다.",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: SMALL_FONT_COLOR,
                          ),
                        ),
                      ],
                    ),
                  if (!widget.isHot)
                    Text(
                      "새롭게 업데이트된 뉴스",
                      style: TextStyle(
                          fontSize: 28.sp,
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.w600),
                    ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              );
            }
            return NewsTile.fromData(data[i - 1]);
          },
          separatorBuilder: (context, i) {
            if (i == 0) return SizedBox.shrink();
            return const Divider(
              thickness: 1.5,
            );
          },
          itemCount: data.length + 1,
          physics: ClampingScrollPhysics(),
        ),
      ),
    );
  }
}
