import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/data/BookmarkCache.dart';
import 'package:tot/common/data/news_data.dart';
import 'package:tot/common/data/news_tile_data.dart';
import 'package:url_launcher/url_launcher.dart';
import '../layout/default_layout.dart';
import 'package:tot/common/const/padding.dart';
import '../view/news_detail_view.dart';
import 'package:tot/common/const/tot_custom_icons_icons.dart';

class NewsDetailHead extends StatefulWidget {
  final String? stockName;
  final String postingDate;
  final String newsTitle;
  late List<String> tagList;
  final String reporter;
  final String press;
  final int id;
  final NewsTileData tileData;
  late bool ismark;

  NewsDetailHead(
      {required this.tagList,
      required this.postingDate,
      required this.newsTitle,
      required this.reporter,
      required this.press,
      required this.id,
      this.stockName,
      required this.tileData,
      Key? key})
      : super(key: key);

  factory NewsDetailHead.fromNewsData(NewsData head) {
    final tile = NewsTileData(
        id: head.id,
        title: head.title,
        created_at: head.created_at,
        summary: head.summary,
        attention_stock: head.attention_stock,
        keywords: head.keywords,
        label: head.label);
    return NewsDetailHead(
      tagList: head.keywords,
      postingDate: head.created_at,
      newsTitle: head.title,
      stockName: head.attention_stock,
      reporter: head.reporter,
      press: head.press,
      id: head.id,
      tileData: tile,
    );
  }

  factory NewsDetailHead.fromNewsTileData(NewsTileData data) {
    return NewsDetailHead(
        tagList: data.keywords,
        postingDate: data.created_at,
        newsTitle: data.title,
        reporter: "reporter",
        press: "press",
        id: data.id,
        tileData: data);
  }

  @override
  State<NewsDetailHead> createState() => _NewsDetailHeadState();
}

int checkBookmark(int id) {
  if (BookmarkCache.to.bookmarks.any((element) => element.id == id)) {
    return 1;
  } else {
    return 0;
  }
}

class _NewsDetailHeadState extends State<NewsDetailHead> {
  late int toggle;
  List<IconData> toggleIcon = [
    ToTCustomIcons.bookmark_off,
    ToTCustomIcons.bookmark_on
  ];

  @override
  void initState() {
    super.initState();
    toggle = checkBookmark(widget.id);
  }

  @override
  Widget build(BuildContext func) {
    final BookmarkCache c = BookmarkCache.to;
    print("test");
    return Container(
      color: NEWSDETAIL_TL_COLOR,
      padding: EdgeInsets.fromLTRB(
          HORIZONTAL_PADDING.w, 20.h, HORIZONTAL_PADDING.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 4.h, 15.w, 0),
                    child: Icon(
                      ToTCustomIcons.back,
                      size: 20.sp,
                    ),
                  )),
              Flexible(
                // width: 300,
                child: Text(
                  widget.newsTitle,
                  style: TextStyle(
                    fontSize: 24.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        widget.press,
                        style: TextStyle(fontSize: 15.sp),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        "${widget.reporter}",
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text("입력 : ${widget.postingDate}",
                      style:
                          TextStyle(color: SMALL_FONT_COLOR, fontSize: 10.sp)),
                ],
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse(
                        'https://www.mk.co.kr/news/economy/${widget.id}'));
                  },
                  child: Icon(
                    Icons.link,
                    size: 30.sp,
                  )),
              SizedBox(
                width: 10.w,
              ),
              GestureDetector(
                onTap: () {
                  var snackbar = null;
                  print(toggle);
                  if (toggle == 0) {
                    c.createBookmark(widget.tileData);
                    snackbar = SnackBar(
                      content: Text("북마크에 추가했습니다."),
                      duration: Duration(milliseconds: 1500),
                      action: SnackBarAction(
                        label: '취소',
                        onPressed: () {
                          c.deleteBookmark(widget.id);
                          setState(() {
                            toggle ^= 1;
                          });
                        },
                      ),
                    );
                  }
                  if (toggle == 1) {
                    c.deleteBookmark(widget.id);
                    snackbar = SnackBar(
                      content: Text("북마크에서 삭제했습니다."),
                      duration: Duration(milliseconds: 1500),
                      action: SnackBarAction(
                        label: '취소',
                        onPressed: () {
                          c.createBookmark(widget.tileData);
                          setState(() {
                            toggle ^= 1;
                          });
                        },
                      ),
                    );
                  }
                  setState(() {
                    toggle ^= 1;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                child: Icon(
                  toggleIcon[toggle],
                  size: 30.sp,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
