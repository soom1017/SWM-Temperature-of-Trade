import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/data/news_tile_data.dart';
import 'package:tot/common/layout/default_layout.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

TextStyle kStyleDefault = TextStyle(
  color: Colors.black,
  fontSize: 16.sp,
  fontWeight: FontWeight.bold,
);

class _SearchViewState extends State<SearchView> {
  final Map<String, List<String>> _keylist = {
    "keywords": List<String>.from([]),
    "stocks": List<String>.from([])
  };
  List<_Keyword> keywords = [];
  RefreshController _controller = RefreshController();

  @override
  void initState() {
    keywords = []
      ..addAll(List<_Keyword>.generate(
        filterKeyword["stocks"].length,
        (index) => _Keyword(
          name: filterKeyword["stocks"][index],
          isStock: true,
        ),
      ))
      ..addAll(List<_Keyword>.generate(
        filterKeyword["keywords"].length,
        (index) => _Keyword(
          name: filterKeyword["keywords"][index],
          isStock: false,
        ),
      ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      isExtraPage: true,
      pageName: "검색",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _search(),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: Text(
              "필터 뉴스",
              style: TextStyle(
                  fontSize: 26.sp,
                  color: PRIMARY_COLOR,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          _list(),
        ],
      ),
    );
  }

  Widget _search() {
    return Container(
      color: HOME_BG_COLOR,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: MultipleSearchSelection<_Keyword>(
          clearSearchFieldOnSelect: true,
          pickedItemsContainerMaxHeight: 100.h,
          title: Container(
            color: Colors.transparent,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.w, 12.h, 12.w, 5.h),
              child: Text(
                '필터',
                style: TextStyle(
                    fontSize: 26.sp,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          onPickedChange: (c) {
            setState(() {
              _keylist.update(
                  "stocks", (value) => List<String>.from(c.where((e) => e.isStock).map((e) => e.name)));
              _keylist.update(
                  "keywords", (value) => List<String>.from(c.where((e) => !e.isStock).map((e) => e.name)));
            });
            print(c.length);
          },
          items: keywords,
          fieldToCheck: (c) {
            return c.name;
          },
          itemBuilder: (_keyword) {
            return Padding(
              padding: EdgeInsets.fromLTRB(6.w, 6.h, 6.w, 6.h),
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
                      style:
                          TextStyle(fontSize: 15.sp, color: SMALL_FONT_COLOR),
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
              '찾기',
              style: TextStyle(fontSize: 17.sp, color: Colors.blueAccent),
            ),
          ),
          fuzzySearch: FuzzySearch.jaro,
          itemsVisibility: ShowedItemsVisibility.toggle,
          showSelectAllButton: false,
          searchFieldInputDecoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            hintText: '검색어를 입력하세요',
            hintStyle: kStyleDefault.copyWith(
              fontSize: 13.sp,
              color: Colors.grey[400],
            ),
          ),
          pickedItemsBoxDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          showShowedItemsScrollbar: false,
          noResultsWidget: Padding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
            child: Text(
              '검색된 키워드가 없습니다.',
              style: kStyleDefault.copyWith(
                color: Colors.grey,
                fontSize: 13.sp,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _noData(){
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
            "조건에 맞는 뉴스가",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "존재하지 않습니다.",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _list() {
    return Flexible(
      child: FutureBuilder(
        future: tokenCheck(() => API.getNewsListByFilter(_keylist)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_keylist["keywords"]!.isEmpty && _keylist["stocks"]!.isEmpty)
            return Container();
          else if(snapshot.data.isEmpty)
            return _noData();
          return Container(
            padding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING.w),
            child: StatefulBuilder(
              builder: (BuildContext context2, setter){
                return _refresher(snapshot.data, setter);
              },
            )
          );
        },
      ),
    );
  }

  Widget _refresher(List<NewsTileData> data, setter){
    return SlidableAutoCloseBehavior(
      child: SmartRefresher(
        controller: _controller,
        onRefresh: () async {
          final _next = await tokenCheck(() => API.getNewsListByFilter(_keylist));
          _controller.refreshCompleted();
          data = _next;
          setter(() {});
        },
        onLoading: () async {
          var _next = null;
          if(!data.isEmpty) {
            _next = await tokenCheck(() =>
                API.getNewsListByFilter(_keylist, newsId: data.last.id));
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
