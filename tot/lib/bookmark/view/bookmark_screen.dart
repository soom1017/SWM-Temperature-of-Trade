import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/API.dart';

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
              '회원가입 후 이용 할 수 있습니다.',
              style: TextStyle(fontSize: 17.sp),
            ),
            content: Text(
              '비회원은 이용 할 수 없는 기능입니다.\n회원가입 하시겠습니까?',
              style: TextStyle(fontSize: 13.sp),
            ),
            actions: <Widget>[
              PlatformDialogAction(
                child: PlatformText("네"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              PlatformDialogAction(
                child: PlatformText("아니오"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      return Container();
    }
    return FutureBuilder(
      future: tokenCheck(() => API.getUserBookmark()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false)
          return Center(child: CircularProgressIndicator());
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
          child: SlidableAutoCloseBehavior(
            child: ListView.separated(
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
                        "북마크 한 뉴스",
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
                return NewsTile.fromData(snapshot.data[i - 1]);
              },
              separatorBuilder: (context, i) {
                if (i == 0) return SizedBox.shrink();
                return const Divider(
                  thickness: 1.5,
                );
              },
              itemCount: snapshot.data.length + 1,
            ),
          ),
        );
      },
    );
  }
}
