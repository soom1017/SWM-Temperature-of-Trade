import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/news_tile_data.dart';
import 'package:tot/common/layout/default_layout.dart';

class KeywordMapScreen extends StatefulWidget {
  final String keyword;

  const KeywordMapScreen({required this.keyword, Key? key}) : super(key: key);

  @override
  State<KeywordMapScreen> createState() => _KeywordMapScreenState();
}

class _KeywordMapScreenState extends State<KeywordMapScreen> {
  RefreshController _controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      pageName: "키워드 지도",
      isExtraPage: true,
      child: FutureBuilder(
        future: Future.wait([API.getNewsListByKeyword(widget.keyword), API.getGraphMapByKeyword(widget.keyword)]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData == false)
            return Center(child: CircularProgressIndicator());
          final List<NewsTileData> _newsTileData = snapshot.data![0];
          final _keywordGraphMap = snapshot.data![1];
          return Stack(
            children: [
              DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.5,
                maxChildSize: 1,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    width: double.infinity,
                    // height: 450,
                    decoration: BoxDecoration(
                      color: NEWSTAB_BG_COLOR,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
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
                      child: StatefulBuilder(
                        builder: (BuildContext context2, setter) {
                          return SmartRefresher(
                            controller: _controller,
                            child: ListView.separated(
                              itemBuilder: (context, i) {
                                return NewsTile.fromData(_newsTileData[i]);
                              },
                              separatorBuilder: (context, i) {
                                return const Divider(
                                  thickness: 1.5,
                                );
                              },
                              itemCount: _newsTileData.length,
                              controller: scrollController,
                              physics: ClampingScrollPhysics(),
                            ),
                            onLoading: () async {
                              final _next = await API.getNewsListByKeyword(widget.keyword, news_id: _newsTileData.last.id);
                              _controller.loadComplete();
                              if(_next != null) {
                                _newsTileData.addAll(_next!);
                              }
                              setter(() {});
                            },
                            enablePullUp: true,
                            enablePullDown: false,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
