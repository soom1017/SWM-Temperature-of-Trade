import 'package:circlegraph/circlegraph.dart';
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
        future: Future.wait([
          API.getNewsListByKeyword(widget.keyword),
          API.getGraphMapByKeyword(widget.keyword)
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData == false)
            return Center(child: CircularProgressIndicator());
          final List<NewsTileData> _newsTileData = snapshot.data![0];
          final _keywordGraphMap = snapshot.data![1];
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleGraph(
                    root: _nodeWithIndex(0),
                    radius: 50,
                    children: [
                      for (int i = 0; i < numberOfChildren + 5; i++)
                        _nodeWithIndex(i + 1),
                    ],
                    circleLayout: [
                      Circle(50, -1),
                    ],
                    // circlify: true,
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
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
                              var _next = null;
                              if (!_newsTileData.isEmpty)
                                _next = await API.getNewsListByKeyword(
                                    widget.keyword,
                                    news_id: _newsTileData.last.id);
                              _controller.loadComplete();
                              if (_next != null) {
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

  int numberOfChildren = 0;

  TreeNodeData _nodeWithIndex(int i) {
    return TreeNodeData<int>(
      child: Text(
        "child $i",
        style: TextStyle(color: Colors.green),
      ),
      data: i,
      onNodeClick: _onNodeClick,
      backgroundColor: Colors.red,
    );
  }

  void _onNodeClick(TreeNodeData node, int data) {
    print("clicked on node $data");
  }
}

// class GraphClusterViewPage extends StatefulWidget {
//   @override
//   _GraphClusterViewPageState createState() => _GraphClusterViewPageState();
// }
//
// class _GraphClusterViewPageState extends State<GraphClusterViewPage> {
//   @override
//   Widget build(BuildContext context) {
//     return InteractiveViewer(
//       child: SizedBox(
//         height: 500,
//         child: GraphView(
//           graph: graph,
//           algorithm: builder,
//           builder: (Node node) {
//             var a = node.key!.value as int?;
//             return rectangWidget(a);
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget rectangWidget(int? i) {
//     return GestureDetector(
//       onTap: () {
//         print(i);
//       },
//       child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4),
//             boxShadow: [
//               BoxShadow(color: Colors.blue, spreadRadius: 2),
//             ],
//           ),
//           child: Text('Node $i')),
//     );
//   }
//
//   final Graph graph = Graph();
//   late Algorithm builder;
//
//   @override
//   void initState() {
//     final a = Node.Id(1);
//     final b = Node.Id(2);
//     final c = Node.Id(3);
//     final d = Node.Id(4);
//     final e = Node.Id(5);
//     final f = Node.Id(6);
//     final g = Node.Id(7);
//     final h = Node.Id(8);
//     final i = Node.Id(9);
//     final j = Node.Id(10);
//     final k = Node.Id(11);
//     final l = Node.Id(12);
//     final m = Node.Id(13);
//     final n = Node.Id(14);
//     final o = Node.Id(15);
//     final p = Node.Id(16);
//     final q = Node.Id(17);
//     final r = Node.Id(18);
//     final s = Node.Id(19);
//     final t = Node.Id(20);
//     final u = Node.Id(21);
//
//     graph.addEdge(a, b);
//     graph.addEdge(a, c);
//     graph.addEdge(a, d);
//     graph.addEdge(a, e);
//     graph.addEdge(a, f);
//     graph.addEdge(b, g);
//     graph.addEdge(b, h);
//     graph.addEdge(b, i);
//     graph.addEdge(c, j);
//     graph.addEdge(c, k);
//     graph.addEdge(c, l);
//     graph.addEdge(d, m);
//     graph.addEdge(d, n);
//     graph.addEdge(d, o);
//     graph.addEdge(e, p);
//     graph.addEdge(e, q);
//     graph.addEdge(e, r);
//     graph.addEdge(f, s);
//     graph.addEdge(f, t);
//     graph.addEdge(f, u);
//
//     builder = FruchtermanReingoldAlgorithm(attractionRate: 0.15,
//       attractionPercentage: 0.15,
//       repulsionPercentage:0.5,
//       repulsionRate:0.4,);
//   }
// }
