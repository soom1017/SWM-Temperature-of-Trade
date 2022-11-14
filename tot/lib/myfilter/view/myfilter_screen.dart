import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/data/news_tile_data.dart';
import 'package:tot/common/view/first_page_view.dart';
import 'package:tot/common/view/root_tab.dart';
import 'package:tot/common/view/search_view.dart';
import 'package:transition/transition.dart';

class MyfilterScreen extends StatefulWidget {
  const MyfilterScreen({Key? key}) : super(key: key);

  @override
  State<MyfilterScreen> createState() => _MyfilterScreenState();
}

class _MyfilterScreenState extends State<MyfilterScreen> {
  final Map<String, List<String>> _keylist = {"keywords": [], "stocks": []};
  List<_Keyword> keywords = [];
  List<_Keyword> stocks = [];

  RefreshController _controller = RefreshController();

  @override
  void initState() {
    stocks = List<_Keyword>.generate(
      filterKeyword["stocks"].length,
      (index) => _Keyword(
        name: filterKeyword["stocks"][index],
        isStock: true,
      ),
    );
    keywords = List<_Keyword>.generate(
      filterKeyword["keywords"].length,
      (index) => _Keyword(
        name: filterKeyword["keywords"][index],
        isStock: false,
      ),
    );

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
                onPressed: () => Get.offAll(() => FirstPageView()),
              ),
              PlatformDialogAction(
                child: PlatformText("아니오"),
                onPressed: () => Get.offAll(() => RootTab()),
              ),
            ],
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      return Container();
    }
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              _search(' 관심종목', true),
              Divider(
                thickness: 1,
              ),
              _search(' 관심키워드', false),
            ],
          ),
        ),
        _Bottom(),
      ],
    );
  }

  Widget _noData(bool isInit) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          Icon(
            Icons.filter_alt_off_outlined,
            size: 100,
          ),
          Text(
            isInit ? "종목과 키워드를" : "조건에 맞는 뉴스가",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            isInit ? "먼저 설정해주세요" : "존재하지 않습니다.",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _Bottom() {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          width: double.infinity,
          // height: 450,
          decoration: BoxDecoration(
            color: NEWSTAB_BG_COLOR,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                HORIZONTAL_PADDING.w, 20.0.h, HORIZONTAL_PADDING.w, 0.0.h),
            child: _list(scrollController),
          ),
        );
      },
    );
  }

  Widget _list(ScrollController scrollController) {
    return FutureBuilder(
      future: tokenCheck(
          () => API.getNewsListByFilter(userFilterKey)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (userFilterKey["keywords"]!.isEmpty && userFilterKey["stocks"]!.isEmpty)
          return _noData(true);
        else if (snapshot.data.isEmpty) return _noData(false);
        return Container(child: StatefulBuilder(
          builder: (BuildContext context2, setter) {
            return _refresher(snapshot.data, setter, scrollController);
          },
        ));
      },
    );
  }

  Widget _refresher(List<NewsTileData> data, setter, scrollController) {
    return SlidableAutoCloseBehavior(
      child: SmartRefresher(
        footer: ClassicFooter(
          loadingText: "불러오는 중입니다.",
          idleText: "당겨서 더보기",
          noDataText: "이전 뉴스가 없습니다.",
          failedText: "불러오기 실패",
          canLoadingText: "이전 뉴스를 불러오기",
        ),
        controller: _controller,
        onLoading: () async {
          List<NewsTileData> _next = [];
          if (data.isNotEmpty) {
            _next = await tokenCheck(() =>
                API.getNewsListByFilter(userFilterKey, newsId: data.last.id));
          }
          if (_next.isNotEmpty) {
            data.addAll(_next);
            _controller.loadComplete();
          }else{
            _controller.loadNoData();
          }
          setter(() {});
        },
        enablePullUp: true,
        enablePullDown: false,
        child: ListView.separated(
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, i) {
            return NewsTile.fromData(data[i]);
          },
          separatorBuilder: (context, i) {
            return const Divider(
              thickness: 1.5,
            );
          },
          itemCount: data.length,
        ),
        scrollController: scrollController,
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  Widget _search(String title, bool isStock) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: MultipleSearchSelection<_Keyword>(
        clearSearchFieldOnSelect: true,
        pickedItemsContainerMaxHeight: 80.h,
        title: Container(
          color: Colors.transparent,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.fromLTRB(5.w, 12.h, 12.w, 5.h),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 26.sp,
                  color: KEYWORD_BG_COLOR,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        initialPickedItems: List<_Keyword>.from(
            userFilterKey[isStock ? "stocks" : "keywords"]!
                .map((e) => _Keyword(name: e, isStock: isStock))),
        onPickedChange: (c) {
          userFilterKey.update(
              isStock ? "stocks" : "keywords",
              (value) => List<String>.from(
                  c.where((e) => e.isStock == isStock).map((e) => e.name)));
          API.updateUserFavorite(userFilterKey);
          setState(() {
            _keylist.update(
                isStock ? "stocks" : "keywords",
                (value) => List<String>.from(
                    c.where((e) => e.isStock == isStock).map((e) => e.name)));
          });
          print(c.length);
        },
        items: isStock ? stocks : keywords,
        fieldToCheck: (c) {
          return c.name;
        },
        itemBuilder: (_keyword) {
          if(userFilterKey[_keyword.isStock ? "stocks" : "keywords"]!.contains(_keyword.name))
            return Container();
          return Padding(
            padding: EdgeInsets.fromLTRB(6.0.w, 6.h, 6.w, 6.h),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: HOME_BG_COLOR,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12.0.h,
                  horizontal: 12.w,
                ),
                child: Text(
                  _keyword.isStock ? _keyword.name : "#${_keyword.name}",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: SMALL_FONT_COLOR,
                  ),
                ),
              ),
            ),
          );
        },
        pickedItemBuilder: (_keyword) {
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFFD8E1E8),
              border: Border.all(color: Color(0xFFD8E1E8)),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    _keyword.name,
                    style: TextStyle(fontSize: 21.sp, color: PRIMARY_COLOR),
                  ),
                  Text(
                    '  ×',
                    style: TextStyle(fontSize: 15.sp, color: SMALL_FONT_COLOR),
                  ),
                ],
              ),
            ),
          );
        },
        clearAllButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Text(
            '필터 초기화',
            style: TextStyle(fontSize: 17.sp, color: Colors.redAccent),
          ),
        ),
        showItemsButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Text(
            isStock ? '종목 찾기' : '키워드 찾기',
            style: TextStyle(fontSize: 17.sp, color: Colors.blueAccent),
          ),
        ),
        fuzzySearch: FuzzySearch.jaro,
        itemsVisibility: ShowedItemsVisibility.toggle,
        showSelectAllButton: false,
        searchFieldInputDecoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
          hintText: '검색어를 입력하세요',
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey[400],
          ),
        ),
        pickedItemsBoxDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        showShowedItemsScrollbar: false,
        noResultsWidget: Padding(
          padding: EdgeInsets.fromLTRB(8.0.w, 8.h, 8.w, 8.h),
          child: Text(
            '검색된 키워드가 없습니다.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13.sp,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ),
    );
  }
}

class _Keyword {
  final String name;
  final bool isStock;

  const _Keyword({
    required this.name,
    required this.isStock,
  });
}
