import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/BookmarkCache.dart';
import 'package:tot/common/data/news_tile_data.dart';
import 'package:tot/common/view/first_page_view.dart';
import 'package:tot/common/view/root_tab.dart';
import 'package:transition/transition.dart' as tr;

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      Future.delayed(
        Duration.zero,
        () => showPlatformDialog(
          context: context,
          builder: (_) => PlatformAlertDialog(
            title: Text(
              '로그인 후 이용 할 수 있습니다.',
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
            ),
            content: Text(
              '게스트는 이용 할 수 없는 기능입니다.\n로그인 하시겠습니까?',
              style: TextStyle(fontSize: 13.sp),
            ),
            actions: <Widget>[
              PlatformDialogAction(
                child: PlatformText("네"),
                onPressed: () => Get.offAll(FirstPageView()),
              ),
              PlatformDialogAction(
                child: PlatformText("아니오"),
                onPressed: () => Get.offAll(RootTab()),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final BookmarkCache c = BookmarkCache.to;
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
      child: SlidableAutoCloseBehavior(
        child: Obx(() {
          List<NewsTileData> _list = c.bookmarks;
          return ListView.separated(
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, i) {
              if (i == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      _list.isEmpty ? "북마크 한 뉴스가 없습니다." : "북마크 한 뉴스",
                      style: TextStyle(
                          fontSize: 30.sp,
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                );
              }
              return NewsTile.fromData(_list[i - 1], fix : true);
            },
            separatorBuilder: (context, i) {
              if (i == 0) return SizedBox.shrink();
              return const Divider(
                thickness: 1.5,
              );
            },
            itemCount: _list.length + 1,
          );
        }),
      ),
    );
  }
}
