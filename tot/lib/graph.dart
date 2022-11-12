import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:tot/common/data/API.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GraphClusterViewPage(),
                  ),
                ),
                child: Text(
                  'Graph Cluster View (FruchtermanReingold)',
                  style: TextStyle(fontSize: 30),
                )),
            SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}


class GraphClusterViewPage extends StatefulWidget {
  @override
  _GraphClusterViewPageState createState() => _GraphClusterViewPageState();
}

class _GraphClusterViewPageState extends State<GraphClusterViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                  constrained: false,
                  boundaryMargin: EdgeInsets.all(8),
                  minScale: 0.001,
                  maxScale: 100,
                  child: GraphView(
                      animated: false,
                      graph: graph,
                      algorithm: builder,
                      paint: Paint()
                        ..color = Colors.green
                        ..strokeWidth = 1
                        ..style = PaintingStyle.fill,
                      builder: (Node node) {
                        // I can decide what widget should be shown here based on the id
                        var a = node.key!.value as int?;
                        if (a == 2) {
                          return rectangWidget(a);
                        }
                        return rectangWidget(a);
                      })),
            ),
          ],
        ));
  }

  Widget rectangWidget(int? i) {
    return GestureDetector(
      onTap: (){
        print(i);
      },
      child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: Colors.blue, spreadRadius: 2),
            ],
          ),
          child: Text('Node $i')),
    );
  }

  final Graph graph = Graph();
  late Algorithm builder;

  @override
  void initState() {
    final a = Node.Id(1);
    final b = Node.Id(2);
    final c = Node.Id(3);
    final d = Node.Id(4);
    final e = Node.Id(5);
    final f = Node.Id(6);
    final g = Node.Id(7);
    final h = Node.Id(8);
    final i = Node.Id(9);
    final j = Node.Id(10);
    final k = Node.Id(11);
    final l = Node.Id(12);
    final m = Node.Id(13);
    final n = Node.Id(14);
    final o = Node.Id(15);
    final p = Node.Id(16);
    final q = Node.Id(17);
    final r = Node.Id(18);
    final s = Node.Id(19);
    final t = Node.Id(20);
    final u = Node.Id(21);


    graph.addEdge(a, b, paint: Paint()..color = Colors.red);
    graph.addEdge(a, c);
    graph.addEdge(a, d);
    graph.addEdge(a, e);
    graph.addEdge(a, f);
    graph.addEdge(b, g);
    graph.addEdge(b, h);
    graph.addEdge(b, i);
    graph.addEdge(c, j);
    graph.addEdge(c, k);
    graph.addEdge(c, l);
    graph.addEdge(d, m);
    graph.addEdge(d, n);
    graph.addEdge(d, o);
    graph.addEdge(e, p);
    graph.addEdge(e, q);
    graph.addEdge(e, r);
    graph.addEdge(f, s);
    graph.addEdge(f, t);
    graph.addEdge(f, u);


    builder = FruchtermanReingoldAlgorithm(iterations: 1000, attractionPercentage: 0.1, attractionRate: 0.1, repulsionPercentage: 0.1, repulsionRate: 0.1);
  }
}