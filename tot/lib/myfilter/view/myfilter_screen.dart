import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/view/search_view.dart';

class MyfilterScreen extends StatefulWidget {
  const MyfilterScreen({Key? key}) : super(key: key);

  @override
  State<MyfilterScreen> createState() => _MyfilterScreenState();
}

class _MyfilterScreenState extends State<MyfilterScreen> {
  List<_Keyword> _keylist = [];

  // 가운뎃점 쓰는 경우가 있음
  final _newsTileList = <NewsTile>[
    NewsTile(
      summary: "asdf",
      newsTitle: "1",
      stockName: "이화전기",
      tagList: ["#인수", "#코스닥", "#위스키"],
      postingDate: "2022.07.29",
      id: 10,
    ),
  ];

  RefreshController _controller = RefreshController();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 29; i++)
      _newsTileList.add(
        NewsTile(
          summary: "asdf",
          newsTitle: "${i + 2}",
          stockName: "이화전기",
          tagList: ["#인수", "#코스닥", "#위스키"],
          postingDate: "2022.07.29",
          id: 10,
        ),
      );
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      Future.delayed(
        Duration.zero,
        () => showPlatformDialog(
          context: context,
          builder: (_) => PlatformAlertDialog(
            title: Text('회원가입 후 이용 할 수 있습니다.'),
            content: Text('비회원은 이용 할 수 없는 기능입니다.\n회원가입 하시겠습니까?'),
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
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              _search(' 관심종목'),
              Divider(
                thickness: 1,
              ),
              _search(' 관심키워드'),
            ],
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return _Bottom(Column(
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
            ));
            // return _Bottom(_list(scrollController));
          },
        ),
      ],
    );
  }

  Widget _Bottom(Widget inner) {
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
        padding: const EdgeInsets.fromLTRB(
            HORIZONTAL_PADDING, 20.0, HORIZONTAL_PADDING, 0.0),
        child: inner,
      ),
    );
  }

  Widget _list(ScrollController scrollController) {
    return StatefulBuilder(
      builder: (BuildContext context2, setter) {
        return SmartRefresher(
          controller: _controller,
          child: ListView.separated(
            itemBuilder: (context, i) {
              return _newsTileList[i];
            },
            separatorBuilder: (context, i) {
              return const Divider(
                thickness: 1.5,
              );
            },
            itemCount: _newsTileList.length,
            controller: scrollController,
            physics: ClampingScrollPhysics(),
          ),
          onLoading: () async {
            await Future.delayed(Duration(milliseconds: 1000));
            _controller.loadComplete();
            for (int i = 0; i < 15; i++) {
              _newsTileList.add(NewsTile(
                summary: "asdf",
                newsTitle: "이화전기, 위스키 브랜드 '윈저' 인수전 참여",
                stockName: "이화전기",
                tagList: ["#인수", "#코스닥", "#위스키"],
                postingDate: "2022.07.29",
                id: 10,
              ));
            }
            setter(() {});
          },
          enablePullUp: true,
          enablePullDown: false,
        );
      },
    );
  }

  Widget _search(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: MultipleSearchSelection<_Keyword>(
        clearSearchFieldOnSelect: true,
        pickedItemsContainerMaxHeight: 80,
        title: Container(
          color: Colors.transparent,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 12, 12, 5),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 26,
                  color: KEYWORD_BG_COLOR,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        onPickedChange: (c) {
          setState(() {
            _keylist = c;
          });
          print(_keylist.length);
        },
        items: keywords,
        // List<_Keyword>
        fieldToCheck: (c) {
          return c.name;
        },
        itemBuilder: (_Keyword) {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: HOME_BG_COLOR,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 12,
                ),
                child: Text(
                  _Keyword.name,
                  style: TextStyle(
                    color: SMALL_FONT_COLOR,
                  ),
                ),
              ),
            ),
          );
        },
        pickedItemBuilder: (_Keyword) {
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFFD8E1E8),
              border: Border.all(color: Color(0xFFD8E1E8)),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    _Keyword.name,
                    style: TextStyle(fontSize: 21, color: PRIMARY_COLOR),
                  ),
                  Text(
                    '  ×',
                    style: TextStyle(fontSize: 15, color: SMALL_FONT_COLOR),
                  ),
                ],
              ),
            ),
          );
        },
        clearAllButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            '필터 초기화',
            style: TextStyle(fontSize: 17, color: Colors.redAccent),
          ),
        ),
        showItemsButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            '키워드 찾기',
            style: TextStyle(fontSize: 17, color: Colors.blueAccent),
          ),
        ),
        fuzzySearch: FuzzySearch.jaro,
        itemsVisibility: ShowedItemsVisibility.toggle,
        showSelectAllButton: false,
        searchFieldInputDecoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          hintText: '검색어를 입력하세요',
          hintStyle: kStyleDefault.copyWith(
            fontSize: 13,
            color: Colors.grey[400],
          ),
        ),
        pickedItemsBoxDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        showShowedItemsScrollbar: false,
        noResultsWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '검색된 키워드가 없습니다.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ),
    );
  }
}

List<_Keyword> keywords = List<_Keyword>.generate(
  keywordList.length,
  (index) => _Keyword(
    name: keywordList[index],
    isStock: false,
  ),
);

class _Keyword {
  final String name;
  final bool isStock;

  const _Keyword({
    required this.name,
    required this.isStock,
  });
}
