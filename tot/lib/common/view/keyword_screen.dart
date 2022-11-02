import 'package:circlegraph/circlegraph.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/news_tile_data.dart';
import 'package:tot/common/layout/default_layout.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
        future: Future.wait([
          API.getNewsListByKeyword(widget.keyword),
          API.getGraphMapByKeyword(widget.keyword)
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData == false)
            return Center(child: CircularProgressIndicator());
          final List<NewsTileData> _newsTileData = snapshot.data![0];
          final _keywordGraphMap = snapshot.data![1];
          print(snapshot.data!);
          return Stack(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    if (_keywordGraphMap != {} && _keywordGraphMap != null)
                      _keywordGraph(_keywordGraphMap['graph'].keys.toList()),
                    if (_keywordGraphMap == {} || _keywordGraphMap == null)
                      _keywordEmpty(),
                  ],
                ),
              ),
              _dragableWidget(_newsTileData),
            ],
          );
        },
      ),
    );
  }

  Widget _keywordEmpty() {
    return Column(
      children: [
        SizedBox(height: 160,),
        Container(
          width: 260,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _keywordButton(widget.keyword, true),
                  ],
                ),
              ),
              Text(
                '관련',
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '키워드 맵이 없습니다.',
          style: TextStyle(fontSize: 30),
        ),
      ],
    );
  }

  Widget _keywordGraph(List<String> keywordList) {
    return CircleGraph(
      edgeColor: PRIMARY_COLOR,
      root: _nodeWithKeyword(keywordList[0], true),
      radius: 10,
      children: [
        for (int i = 1; i < 6; i++) _nodeWithKeyword(keywordList[i], false),
      ],
      backgroundColor: Colors.transparent,
    );
  }

  Widget _dragableWidget(List<NewsTileData> data) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 1,
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
            padding: const EdgeInsets.fromLTRB(
                HORIZONTAL_PADDING, 20.0, HORIZONTAL_PADDING, 0.0),
            child: StatefulBuilder(
              builder: (BuildContext context2, setter) {
                return _refresher(data, scrollController, setter);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _refresher(List<NewsTileData> data, ScrollController scrollController,
      Function setter) {
    return SlidableAutoCloseBehavior(
      child: SmartRefresher(
        controller: _controller,
        onLoading: () async {
          var _next = null;
          if (data.isNotEmpty) {
            _next = await API.getNewsListByKeyword(widget.keyword,
                news_id: data.last.id);
          }
          _controller.loadComplete();
          if (_next != null) {
            data.addAll(_next!);
          }
          setter(() {});
        },
        enablePullUp: true,
        enablePullDown: false,
        child: ListView.separated(
          itemBuilder: (context, i) {
            return NewsTile.fromData(data[i]);
          },
          separatorBuilder: (context, i) {
            return const Divider(
              thickness: 1.5,
            );
          },
          itemCount: data.length,
          controller: scrollController,
          physics: ClampingScrollPhysics(),
        ),
      ),
    );
  }

  TreeNodeData _nodeWithKeyword(String name, bool isRoot) {
    return TreeNodeData<String>(
      width: 130,
      child: _keywordButton(name, isRoot),
      data: name,
      onNodeClick: isRoot ? null : _onNodeClick,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _keywordButton(String name, bool isRoot) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        decoration: BoxDecoration(
          color: isRoot ? PRIMARY_COLOR : Color(0xFF4099DD),
          borderRadius: BorderRadius.circular(isRoot ? 10 : 30),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
          child: Text(
            isRoot ? '#$name' : name,
            style: TextStyle(
                color: isRoot ? Colors.white : Colors.black, fontSize: 28),
          ),
        ),
      ),
    );
  }

  void _onNodeClick(TreeNodeData node, String data) {
    print("clicked on node $data");
  }
}
