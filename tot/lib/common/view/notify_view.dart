import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/AppController.dart';
import 'package:tot/common/data/cache.dart';
import '../layout/default_layout.dart';

class NotifyView extends StatefulWidget {
  const NotifyView({Key? key}) : super(key: key);

  @override
  State<NotifyView> createState() => _NotifyViewState();
}

class _NotifyViewState extends State<NotifyView> {
  RefreshController _controller = RefreshController();
  final AppController c = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      pageName: "알림",
      isExtraPage: true,
      child: FutureBuilder(
        future: tokenCheck(() => API.getNewsListByFilter(userFilterKey)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false)
            return Center(child: CircularProgressIndicator());
          return Center(
            child: Obx(() {
              return Column(
                children: [
                  Text(c.message.value?.notification?.title ?? 'title',
                      style: TextStyle(fontSize: 20.sp)),
                  Text(c.message.value?.notification?.body ?? 'message',
                      style: TextStyle(fontSize: 15.sp)),
                ],
              );
            }),
          );
          // return Container(
          //   padding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING.w),
          //   // padding: const EdgeInsets.fromLTRB(HORIZONTAL_PADDING, 0, 5 ,0),
          //   child: StatefulBuilder(
          //     builder: (BuildContext context2, setter) {
          //       return _refresher(snapshot.data, setter);
          //     },
          //   ),
          // );
        },
      ),
    );
  }

  Widget _refresher(data, setter) {
    return SlidableAutoCloseBehavior(
      child: SmartRefresher(
        controller: _controller,
        onRefresh: () async {
          var _next = null;
          _next =
              await tokenCheck(() => API.getNewsListByFilter(userFilterKey));
          _controller.refreshCompleted();
          data = _next;
          setter(() {});
        },
        onLoading: () async {
          var _next = null;
          if (!data.isEmpty) {
            await tokenCheck(() =>
                API.getNewsListByFilter(userFilterKey, newsId: data.last.id));
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
                  Text(
                    "아직 못 본 관심 뉴스",
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
