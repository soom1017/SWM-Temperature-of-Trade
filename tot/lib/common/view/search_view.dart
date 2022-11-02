import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphview/GraphView.dart';
import 'package:multiple_search_selection/helpers/create_options.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/layout/default_layout.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

TextStyle kStyleDefault = const TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

class _SearchViewState extends State<SearchView> {
  List<_Keyword> _keylist = [];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      isExtraPage: true,
      pageName: "검색",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _search(),
          Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("필터 뉴스", style: TextStyle(
                fontSize: 26,
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.w600),),
          ),
          SizedBox(height: 20,),
          _list(),
        ],
      ),
    );
  }

  Widget _search() {
    return Container(
      color: HOME_BG_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: MultipleSearchSelection<_Keyword>(
          clearSearchFieldOnSelect: true,
          pickedItemsContainerMaxHeight: 100,
          title: Container(
            color: Colors.transparent,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 12, 12, 5),
              child: Text(
                '필터',
                style: TextStyle(
                    fontSize: 26,
                    color: PRIMARY_COLOR,
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
              '찾기',
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
              style: kStyleDefault.copyWith(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _list(){
    return Flexible(
      child: FutureBuilder(
        future: API.getUserBookmark(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false)
            return Center(child: CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
            child: SlidableAutoCloseBehavior(
              child: ListView.separated(
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, i) {
                  return NewsTile.fromData(snapshot.data[i]);
                },
                separatorBuilder: (context, i) {
                  return const Divider(
                    thickness: 1.5,
                  );
                },
                itemCount: snapshot.data.length,
              ),
            ),
          );
        },
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
