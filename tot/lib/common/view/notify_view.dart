import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/AppController.dart';
import 'package:tot/common/view/news_detail_view.dart';
import '../layout/default_layout.dart';

class NotifyView extends StatefulWidget {
  const NotifyView({Key? key}) : super(key: key);

  @override
  State<NotifyView> createState() => _NotifyViewState();
}

class _NotifyViewState extends State<NotifyView> {
  final AppController c = Get.put(AppController());
  List<Map<String, dynamic>>? notifyList;
  List<Map<String, dynamic>> test = [
    {
      "id": 123451,
      "title": "가나다라마바사아자차카타파하가나다라마바사아자차카타파하",
      "time": "2022-04-24T14:21:00",
    },
    {
      "id": 41341,
      "title": "차카타파하가나다라마바사아자차카타파하",
      "time": "2022-02-24T14:21:00",
    },
    {
      "id": 5123212,
      "title": "라마바사아자차카타파하가나다라마바사아자차카타파하",
      "time": "2022-01-24T14:21:00",
    }
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    final temp = await AppController.storage.read(key: "notify");
    final List<dynamic> list = json.decode(temp ?? "[]");
    notifyList = list.map((e) => Map<String, dynamic>.from(e)).toList();
    // notifyList = test;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      pageName: "알림",
      isExtraPage: true,
      child: Container(
        color: NEWSTAB_BG_COLOR,
        padding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _head(),
            _list(),
          ],
        ),
      ),
    );
  }

  Widget _head() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 12.h, 0, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "뉴스 알림",
            style: TextStyle(
                fontSize: 35.sp,
                color: KEYWORD_BG_COLOR,
                fontWeight: FontWeight.w600),
          ),
          Text(
            "회원님의 관심사와 관련된 새로운 뉴스를 표시해드립니다.",
            style: TextStyle(fontSize: 13.sp, color: SMALL_FONT_COLOR),
          ),
        ],
      ),
    );
  }

  Widget _list() {
    return Flexible(
      child: SlidableAutoCloseBehavior(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            if (notifyList == null) {
              return Container();
            }
            return NotificationTile.fromNotify(notifyList![i], () async {
              notifyList!.removeAt(i);
              await AppController.storage
                  .write(key: "notify", value: json.encode(notifyList));
              setState(() {});
            });
          },
          separatorBuilder: (context, i) {
            return const Divider(
              thickness: 1.5,
            );
          },
          itemCount: notifyList?.length ?? 0,
          physics: ClampingScrollPhysics(),
        ),
      ),
    );
  }
}

class NotificationTile extends StatefulWidget {
  final String title;
  final DateTime time;
  final int id;
  final Function func;

  const NotificationTile({
    Key? key,
    required this.title,
    required this.time,
    required this.id,
    required this.func,
  }) : super(key: key);

  factory NotificationTile.fromNotify(
      Map<String, dynamic> data, Function func) {
    print("notify : " + data.toString());
    final String title = data["title"];
    final DateTime time = DateTime.parse(data["time"]);
    final int id = data["id"];
    return NotificationTile(
      title: title,
      time: time,
      id: id,
      func: func,
    );
  }

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(widget.id.toString()),
      onDismissed: (_) {
        widget.func();
      },
      child: _tile(),
    );
  }

  routeToNewsDetailPage() {
    Get.to(() => NewsDetailView.fromNewsId(widget.id));
  }

  Widget _tile() {
    final t = widget.time;
    return GestureDetector(
      onTap: () {
        routeToNewsDetailPage();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${t.year}.${t.month.toString().padLeft(2, '0')}.${t.day.toString().padLeft(2, '0')} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                  fontSize: 15.sp,
                  color: KEYWORD_BG_COLOR,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 7.h,
            ),
            Text(
              overflow: TextOverflow.ellipsis,
              widget.title,
              style: TextStyle(
                fontSize: 19.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
