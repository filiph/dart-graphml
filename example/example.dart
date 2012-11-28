import 'dart:io';
import 'package:graphml/dart_graphml.dart';


void main() {
  File f = new File("${(new Path(new Options().script)).directoryPath}/thinice.graphml");
  GraphML graph = new GraphML.fromFile(f);
  
  var n = new Node("Newly created node");
  graph.addNode(n);
  graph.addEdge(graph.nodes[0], n);
  
  var gn = new Node("New group");
  graph.addGroupNode(gn);
  var cn = new Node("Node in group", parent:gn);
  graph.addNode(cn);
  
  graph.addEdge(n, cn);

  File f2 = new File("${(new Path(new Options().script)).directoryPath}/new.graphml");
  var raf = f2.openSync(FileMode.WRITE);
  raf.writeStringSync(graph.toString().replaceAll('\r', '\n'), Encoding.UTF_8);
  raf.close();
}