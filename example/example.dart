import 'dart:convert';
import 'dart:io';
import 'package:graphml/dart_graphml.dart';

void main() {
  File f = File("example/thinice.graphml");
  GraphML graph = GraphML.fromFile(f);

  var n = Node("Newly created node");
  graph.addNode(n);
  graph.addEdge(graph.nodes[0], n);

  var gn = Node("New group");
  graph.addGroupNode(gn);
  var cn = Node("Node in group", parent: gn);
  graph.addNode(cn);

  graph.addEdge(n, cn);

  File f2 = File("example/new.graphml");
  var raf = f2.openSync(mode: FileMode.write);
  raf.writeStringSync(graph.toString().replaceAll('\r', '\n'), encoding: utf8);
  raf.close();
}
