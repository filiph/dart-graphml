library Dart_GraphML;

import 'dart:io';
import 'package:xml/xml.dart';

class Node {
  String id;
  String text;
  num x;
  num y;
  Node parent;
  List<Node> children;
  List<Node> linkedNodes;

  XmlElement xmlEl;

  Node(this.text, {this.parent: null}) {
    children = new List<Node>();
    linkedNodes = new List<Node>();
  }

  String toString() {
    return "$text [$id]";
  }

  get fullText {
    if (parent != null) {
      return "${parent.text}: $text";
    } else {
      return text;
    }
  }

  XmlElement createNewNodeXml() {
    return parse("""
        <node id="$id">
          <data key="d6">
            <yCOLONShapeNode>
            <yCOLONGeometry height="30.0" width="100.0" x="$x" y="$y"></yCOLONGeometry>
            <yCOLONFill color="#FFCC00" transparent="false"></yCOLONFill>
            <yCOLONBorderStyle color="#000000" type="line" width="1.0"></yCOLONBorderStyle>
            <yCOLONNodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="18.1328125" modelName="custom" textColor="#000000" visible="true">$text<yCOLONLabelModel>
            <yCOLONSmartNodeLabelModel distance="4.0"></yCOLONSmartNodeLabelModel>
            </yCOLONLabelModel>
            <yCOLONModelParameter>
            <yCOLONSmartNodeLabelModelParameter labelRatioX="0.0" labelRatioY="0.0" nodeRatioX="0.0" nodeRatioY="0.0" offsetX="0.0" offsetY="0.0" upX="0.0" upY="-1.0"></yCOLONSmartNodeLabelModelParameter>
            </yCOLONModelParameter>
            </yCOLONNodeLabel>
            <yCOLONShape type="rectangle"></yCOLONShape>
            </yCOLONShapeNode>
          </data>
        </node>
    """).rootElement;
  }

  XmlElement createNewGroupNodeXml() {
    return parse("""
      <node id="$id" yfiles.foldertype="group">
         <data key="d4"></data>
         <data key="d6">
            <yCOLONProxyAutoBoundsNode>
               <yCOLONRealizers active="0">
                  <yCOLONGroupNode>
                     <yCOLONGeometry height="300.0" width="212.21547619047618" x="$x" y="$y"></yCOLONGeometry>
                     <yCOLONFill color="#F5F5F5" transparent="false"></yCOLONFill>
                     <yCOLONBorderStyle color="#000000" type="dashed" width="1.0"></yCOLONBorderStyle>
                     <yCOLONNodeLabel alignment="right" autoSizePolicy="node_width" backgroundColor="#EBEBEB" borderDistance="0.0" fontFamily="Dialog" fontSize="15" fontStyle="plain" hasLineColor="false" height="21.666015625" modelName="internal" modelPosition="t" textColor="#000000" visible="true" width="212.21547619047618" x="0.0" y="0.0">$text</yCOLONNodeLabel>
                     <yCOLONShape type="roundrectangle"></yCOLONShape>
                     <yCOLONState closed="false" closedHeight="50.0" closedWidth="50.0" innerGraphDisplayEnabled="false"></yCOLONState>
                     <yCOLONNodeBounds considerNodeLabelSize="true"></yCOLONNodeBounds>
                     <yCOLONInsets bottom="15" bottomF="15.0" left="15" leftF="15.0" right="15" rightF="15.0" top="15" topF="15.0"></yCOLONInsets>
                     <yCOLONBorderInsets bottom="0" bottomF="0.0" left="1" leftF="1.0003069196429237" right="1" rightF="1.0002077132936051" top="0" topF="0.0"></yCOLONBorderInsets>
                  </yCOLONGroupNode>
                  <yCOLONGroupNode>
                     <yCOLONGeometry height="50.0" width="50.0" x="47.8857142857143" y="-36.666015625"></yCOLONGeometry>
                     <yCOLONFill color="#F5F5F5" transparent="false"></yCOLONFill>
                     <yCOLONBorderStyle color="#000000" type="dashed" width="1.0"></yCOLONBorderStyle>
                     <yCOLONNodeLabel alignment="right" autoSizePolicy="node_width" backgroundColor="#EBEBEB" borderDistance="0.0" fontFamily="Dialog" fontSize="15" fontStyle="plain" hasLineColor="false" height="21.666015625" modelName="internal" modelPosition="t" textColor="#000000" visible="true" width="63.75830078125" x="0.0" y="0.0">$text (folded)</yCOLONNodeLabel>
                     <yCOLONShape type="roundrectangle"></yCOLONShape>
                     <yCOLONState closed="true" closedHeight="50.0" closedWidth="50.0" innerGraphDisplayEnabled="false"></yCOLONState>
                     <yCOLONInsets bottom="5" bottomF="5.0" left="5" leftF="5.0" right="5" rightF="5.0" top="5" topF="5.0"></yCOLONInsets>
                     <yCOLONBorderInsets bottom="0" bottomF="0.0" left="0" leftF="0.0" right="0" rightF="0.0" top="0" topF="0.0"></yCOLONBorderInsets>
                  </yCOLONGroupNode>
               </yCOLONRealizers>
            </yCOLONProxyAutoBoundsNode>
         </data>
         <graph edgedefault="directed" id="$id:">
         </graph>
      </node>
    """).rootElement;
  }
}

class GraphML {
  List<Node> groupNodes;
  List<Node> nodes;

  Map<String, Node> groupNodeById;
  Map<String, Node> nodeById;

  static const String _yEdPrefix = "y:";
  static const String _yEdPrefixSub = "yCOLON";

  XmlElement xmlRoot;
  XmlElement xmlRootGraph;

  /**
   * Creates an empty graphml.
   */
  GraphML() {
    groupNodes = new List<Node>();
    nodes = new List<Node>();

    groupNodeById = new Map<String, Node>();
    nodeById = new Map<String, Node>();
  }

  /**
   * Creates the GraphML instance from a valid .graphml file.
   */
  GraphML.fromFile(File f) {
    RandomAccessFile raf = f.openSync();
    int len = f.lengthSync();
    List<int> buffer = new List<int>(len);
    raf.readIntoSync(buffer, 0, len);
    raf.close();

    String xml = new String.fromCharCodes(buffer);

    // use hacks to get rid of nodes that dart-xml can't handle
    // TODO: remove -- we don't need this anymore
    xml = xml
        .replaceAll(new RegExp(r"<\?.*?\?>"), "") // get rid of PI node(s)
        .replaceAll("<$_yEdPrefix", "<$_yEdPrefixSub") // get rid of `y:`
        .replaceAll("</$_yEdPrefix", "</$_yEdPrefixSub");

    xmlRoot = parse(xml).rootElement;
    xmlRootGraph = xmlRoot.findElements("graph").first;
    assert(xmlRootGraph.getAttribute("id") == "G");

    groupNodes = new List<Node>();
    nodes = new List<Node>();

    groupNodeById = new Map<String, Node>();
    nodeById = new Map<String, Node>();

    xmlRootGraph.findAllElements("node").forEach((XmlElement xmlNode) {
      if (xmlNode.attributes
          .any((attr) => attr.name.local == "yfiles.foldertype")) {
        // GroupNode found
        XmlElement nodeLabel =
            xmlNode.findAllElements("${_yEdPrefixSub}NodeLabel").first;
        Node node = new Node(nodeLabel.text);
        node.id = xmlNode.getAttribute("id");
        XmlElement nodeGeometry =
            xmlNode.findAllElements("${_yEdPrefixSub}Geometry").first;
        node.x = double.parse(nodeGeometry.getAttribute("x"));
        node.y = double.parse(nodeGeometry.getAttribute("y"));
        node.xmlEl = xmlNode;
        groupNodes.add(node);
        groupNodeById[node.id] = node;
      } else {
        // Normal node found
        XmlElement nodeLabel =
            xmlNode.findAllElements("${_yEdPrefixSub}NodeLabel").first;
        Node node = new Node(nodeLabel.text);
        node.id = xmlNode.getAttribute("id");
        XmlElement nodeGeometry =
            xmlNode.findAllElements("${_yEdPrefixSub}Geometry").first;
        node.x = double.parse(nodeGeometry.getAttribute("x"));
        node.y = double.parse(nodeGeometry.getAttribute("y"));
        node.xmlEl = xmlNode;
        if (node.id.contains("::")) {
          // belongs to a groupNode (at least in yEd notation)
          // TODO: less yEd, more generic - group nodes have their nodes inside
          node.parent = groupNodeById[node.id.split("::").first];
          node.parent.children.add(node);
        }
        nodes.add(node);
        nodeById[node.id] = node;
      }
    });

    xmlRoot.findAllElements("edge").forEach((XmlElement edge) {
      nodeById[edge.getAttribute("source")]
          .linkedNodes
          .add(nodeById[edge.getAttribute("target")]);
    });
  }

  static int _nodeNumber = 10000;

  void addNode(Node node) {
    if (node.parent != null) {
      node.id = "${node.parent.id}::${_nodeNumber++}";
    } else {
      node.id = "n${_nodeNumber++}";
    }
    nodes.add(node);

    if (node.x == null) {
      node.x = 0;
    }
    ;
    if (node.y == null) {
      node.y = 0;
    }
    ;

//    XmlElement newXml = node.createNewNodeXml();
//
//    if (node.parent != null && node.parent.xmlEl != null) {
//      (node.parent.xmlEl.query("graph")[0] as XmlElement).addChild(newXml);
//    } else {
//      xmlRootGraph.addChild(newXml);
//    }
//
//    node.xmlEl = newXml;
  }

  void addGroupNode(Node node) {
    if (node.parent != null) {
      node.id = "${node.parent.id}::${_nodeNumber++}";
    } else {
      node.id = "n${_nodeNumber++}";
    }
    groupNodes.add(node);

    if (node.x == null) {
      node.x = 0;
    }
    ;
    if (node.y == null) {
      node.y = 0;
    }
    ;

//    if (node.parent != null && node.parent.xmlEl != null) {
//      (node.parent.xmlEl.query("graph")[0] as XmlElement).addChild(newXml);
//    } else {
//      xmlRootGraph.addChild(newXml);
//    }
//
//    node.xmlEl = newXml;
  }

  static int _edgeNumber = 10000;

  void addEdge(Node source, Node target) {
    source.linkedNodes.add(target);

//    XmlElement newXml = XML.parse("""
//      <edge id="e${_edgeNumber++}" source="${source.id}" target="${target.id}">
//         <data key="d10">
//            <yCOLONPolyLineEdge>
//               <yCOLONPath sx="-39.47216796875" sy="15.0" tx="-17.26220703125" ty="-15.0"></yCOLONPath>
//               <yCOLONLineStyle color="#000000" type="line" width="1.0"></yCOLONLineStyle>
//               <yCOLONArrows source="none" target="standard"></yCOLONArrows>
//               <yCOLONBendStyle smoothed="false"></yCOLONBendStyle>
//            </yCOLONPolyLineEdge>
//         </data>
//      </edge>
//    """);
//
//    xmlRootGraph.addChild(newXml);
  }

  void createXml() {
    xmlRoot = createNewXml();
    xmlRootGraph = xmlRoot.findElements("graph").first;
    assert(xmlRootGraph.getAttribute("id") == "G");

    groupNodes.forEach((Node groupNode) {
      groupNode.xmlEl = groupNode.createNewGroupNodeXml();
      xmlRootGraph.children.add(groupNode.xmlEl.copy());
    });

    nodes.forEach((Node node) {
      node.xmlEl = node.createNewNodeXml();
      if (node.parent != null && node.parent.xmlEl != null) {
        node.parent.xmlEl
            .findElements("graph")
            .first
            .children
            .add(node.xmlEl.copy());
      } else {
        xmlRootGraph.children.add(node.xmlEl.copy());
      }
    });

    nodes.forEach((Node source) {
      source.linkedNodes.forEach((Node target) {
        xmlRootGraph.children.add(createNewEdgeXml(source, target).copy());
      });
    });
  }

  XmlElement createNewXml() {
    return parse("""
      <graphml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:y="http://www.yworks.com/xml/graphml" xmlns:yed="http://www.yworks.com/xml/yed/3" xmlns="http://graphml.graphdrawing.org/xmlns" xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://www.yworks.com/xml/schema/graphml/1.1/ygraphml.xsd">
         <key for="graphml" id="d0" yfiles.type="resources"></key>
         <key for="port" id="d1" yfiles.type="portgraphics"></key>
         <key for="port" id="d2" yfiles.type="portgeometry"></key>
         <key for="port" id="d3" yfiles.type="portuserdata"></key>
         <key attr.name="url" attr.type="string" for="node" id="d4"></key>
         <key attr.name="description" attr.type="string" for="node" id="d5"></key>
         <key for="node" id="d6" yfiles.type="nodegraphics"></key>
         <key attr.name="Description" attr.type="string" for="graph" id="d7"></key>
         <key attr.name="url" attr.type="string" for="edge" id="d8"></key>
         <key attr.name="description" attr.type="string" for="edge" id="d9"></key>
         <key for="edge" id="d10" yfiles.type="edgegraphics"></key>
         <graph edgedefault="directed" id="G">
            <data key="d7"></data>
         </graph>
         <data key="d0">
            <yCOLONResources></yCOLONResources>
         </data>
      </graphml>
    """).rootElement;
  }

  XmlElement createNewEdgeXml(Node source, Node target) {
    return parse("""
      <edge id="e${_edgeNumber++}" source="${source.id}" target="${target.id}">
         <data key="d10">
            <yCOLONPolyLineEdge>
               <yCOLONPath sx="-39.47216796875" sy="15.0" tx="-17.26220703125" ty="-15.0"></yCOLONPath>
               <yCOLONLineStyle color="#000000" type="line" width="1.0"></yCOLONLineStyle>
               <yCOLONArrows source="none" target="standard"></yCOLONArrows>
               <yCOLONBendStyle smoothed="false"></yCOLONBendStyle>
            </yCOLONPolyLineEdge>
         </data>
      </edge>
    """).rootElement;
  }

  void updateXml() {
    // TODO: just update what we have, add new stuff
    createXml();
  }

  // TODO: get xmlGraph - first call updateXml

  String toString() {
    updateXml();

    var strBuf = new StringBuffer();
    strBuf.write('<?xml version="1.0" encoding="UTF-8" standalone="no"?>');
    strBuf.write(xmlRoot.toString().replaceAll(
        _yEdPrefixSub, _yEdPrefix)); // another hack around y: prefix
    return strBuf.toString();
  }
}
