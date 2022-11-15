import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/data/news_tile_data.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final FocusNode textFocus = FocusNode();
  final Map<String, List<String>> _keylist = {
    "keywords": List<String>.from([]),
    "stocks": List<String>.from([])
  };

  List<_Keyword> keywords = [];
  List<_Keyword> selectedItems = [];
  final RefreshController _refreshController = RefreshController();
  final _textController = TextEditingController();

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

  List<_Keyword> matcher(pattern) {
    if (pattern == '') {
      return [];
    }
    return keywords
        .where((element) => element.name
            .toLowerCase()
            .contains(pattern.toString().toLowerCase()))
        .toList();
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: BG_COLOR,
      foregroundColor: Colors.black,
      title: Container(
        width: double.infinity,
        height: 40.h,
        decoration: BoxDecoration(
            color: Color(0xFFF3F8FC), borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: TypeAheadFormField(
            hideOnLoading: true,
            noItemsFoundBuilder: (_) {
              return Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
                child: Text(
                  '검색된 키워드가 없습니다.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.sp,
                  ),
                ),
              );
            },
            textFieldConfiguration: TextFieldConfiguration(
              controller: _textController,
              focusNode: textFocus,
              decoration: InputDecoration(
                hintText: "검색어를 입력해주세요.",
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: GestureDetector(
                  child: const Icon(Icons.clear),
                  onTap: _textController.clear,
                ),
              ),
            ),
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              constraints: BoxConstraints(
                maxHeight: 300.h,
              ),
            ),
            suggestionsCallback: (pattern) {
              return matcher(pattern);
            },
            hideKeyboardOnDrag: true,
            hideSuggestionsOnKeyboardHide: false,
            itemBuilder: (context, _Keyword suggestion) {
              return suggestionItem(suggestion);
            },
            onSuggestionSelected: (_Keyword suggestion) {
              selectedItems.add(suggestion);
              keywords.remove(suggestion);
              _textController.clear();
              setState(() {
                if (suggestion.isStock) {
                  _keylist["stocks"]!.add(suggestion.name);
                } else {
                  _keylist["keywords"]!.add(suggestion.name);
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Widget suggestionItem(_keyword) {
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
  }

  Widget selectedItem(_Keyword _keyword) {
    return GestureDetector(
      onTap: () {
        selectedItems.remove(_keyword);
        keywords.add(_keyword);
        setState(() {
          if (_keyword.isStock) {
            _keylist["stocks"]!.remove(_keyword.name);
          } else {
            _keylist["keywords"]!.remove(_keyword.name);
          }
        });
      },
      child: Container(
        height: 32.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color(0xFFD8E1E8),
        ),
        padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  _keyword.name,
                  style: TextStyle(fontSize: 17.sp, color: PRIMARY_COLOR),
                ),
                Text(
                  '  ×',
                  style: TextStyle(fontSize: 15.sp, color: SMALL_FONT_COLOR),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        textFocus.unfocus();
      },
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  Widget _filter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      decoration: BoxDecoration(
        color: Color(0xFFF3F8FC),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "필터",
                style: TextStyle(
                  fontSize: 22.sp,
                  color: PRIMARY_COLOR,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  // 초기화
                  keywords.addAll(selectedItems);
                  _keylist["stocks"]!.removeWhere((element) =>
                      selectedItems.any((e) => e.isStock && e.name == element));
                  _keylist["keywords"]!.removeWhere((element) => selectedItems
                      .any((e) => !e.isStock && e.name == element));
                  selectedItems.clear();
                  // 불러오기
                  selectedItems.addAll(List<_Keyword>.from(
                      userFilterKey["stocks"]!
                          .map((e) => _Keyword(name: e, isStock: true))));
                  selectedItems.addAll(List<_Keyword>.from(
                      userFilterKey["keywords"]!
                          .map((e) => _Keyword(name: e, isStock: false))));
                  keywords.removeWhere(
                      (element) => selectedItems.contains(element));
                  _keylist["stocks"]!.addAll(userFilterKey["stocks"]!);
                  _keylist["keywords"]!.addAll(userFilterKey["keywords"]!);
                  setState(() {});
                },
                child: Text(
                  "마이필터 불러오기",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: PRIMARY_COLOR,
                  ),
                ),
              ),
              SizedBox(
                width: 25.w,
              ),
              GestureDetector(
                onTap: () {
                  keywords.addAll(selectedItems);
                  _keylist["stocks"]!.removeWhere((element) =>
                      selectedItems.any((e) => e.isStock && e.name == element));
                  _keylist["keywords"]!.removeWhere((element) => selectedItems
                      .any((e) => !e.isStock && e.name == element));
                  selectedItems.clear();
                  setState(() {});
                },
                child: Text(
                  "전체삭제",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          SizedBox(
            height: 80.h,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                  spacing: 5.w,
                  runSpacing: 5.w,
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.start,
                  children: selectedItems.map((e) => selectedItem(e)).toList()),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _filter(),
        _list(),
      ],
    );
  }

  Widget _noData() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40.h,
          ),
          Icon(
            Icons.filter_alt_off_outlined,
            size: 100.sp,
          ),
          Text(
            "조건에 맞는 뉴스가",
            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            "존재하지 않습니다.",
            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _list() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: Text(
              "필터 뉴스",
              style: TextStyle(
                fontSize: 22.sp,
                color: PRIMARY_COLOR,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          FutureBuilder(
            future: tokenCheck(() => API.getNewsListByFilter(_keylist)),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print("test");
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_keylist["keywords"]!.isEmpty &&
                  _keylist["stocks"]!.isEmpty) {
                return Container();
              } else if (snapshot.connectionState == ConnectionState.done && snapshot.data.isEmpty) {
                return _noData();
              }
              return Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING.w),
                  child: StatefulBuilder(
                    builder: (BuildContext context2, setter) {
                      return _refresher(snapshot.data, setter);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _refresher(List<NewsTileData> data, setter) {
    return SlidableAutoCloseBehavior(
      child: SmartRefresher(
        controller: _refreshController,
        header: ClassicHeader(
          refreshingText: "불러오는 중입니다.",
          releaseText: "새로고침",
          idleText: "당겨서 새로고침",
          completeText: "새로고침 되었습니다.",
          failedText: "새로고침 실패",
        ),
        footer: ClassicFooter(
          loadingText: "불러오는 중입니다.",
          idleText: "당겨서 더보기",
          noDataText: "이전 뉴스가 없습니다.",
          failedText: "불러오기 실패",
          canLoadingText: "이전 뉴스를 불러오기",
        ),
        onRefresh: () async {
          final _next =
              await tokenCheck(() => API.getNewsListByFilter(_keylist));
          _refreshController.refreshCompleted();
          data = _next;
          setter(() {});
        },
        onLoading: () async {
          List<NewsTileData> _next = [];
          if (data.isNotEmpty) {
            _next = await tokenCheck(
                () => API.getNewsListByFilter(_keylist, newsId: data.last.id));
          }
          if (_next.isNotEmpty) {
            data.addAll(_next);
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
          setter(() {});
        },
        enablePullUp: true,
        enablePullDown: true,
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
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
