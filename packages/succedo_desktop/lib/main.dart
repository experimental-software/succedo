import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';

void main(List<String> arguments) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Erstellung von Git Workshop Webseite'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TreeViewController _treeViewController;

  List<Node> nodes = [
    Node(
      label: 'Documents',
      key: 'docs',
      expanded: true,
      icon: NodeIcon(
        codePoint: Icons.folder_open.codePoint,
        color: "blue",
      ),
      children: [
        Node(
            label: 'Job Searchs',
            key: 'd3',
            icon: NodeIcon.fromIconData(Icons.input),
            children: [
              Node(
                  label: 'Resume.docx',
                  key: 'pd1',
                  icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
              Node(
                  label: 'Cover Letter.docx',
                  key: 'pd2',
                  icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
            ]),
        Node(
          label: 'Inspection2.docx',
          key: 'd1',
        ),
        Node(
            label: 'Invoice.docx',
            key: 'd2',
            icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
      ],
    ),
    Node(
        label: 'MeetingReport.xls',
        key: 'mrxls',
        icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
    Node(
        label: 'MeetingReport2.pdf',
        key: 'mrpdf',
        icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
    Node(
        label: 'End.zip',
        key: 'demo',
        icon: NodeIcon.fromIconData(Icons.archive)),
  ];

  TreeViewTheme _treeViewTheme = TreeViewTheme(
    expanderTheme: ExpanderThemeData(
      type: ExpanderType.caret,
      modifier: ExpanderModifier.none,
      position: ExpanderPosition.start,
      color: Colors.red.shade800,
      size: 20,
    ),
    labelStyle: TextStyle(
      fontSize: 16,
      letterSpacing: 0.3,
    ),
    parentLabelStyle: TextStyle(
      fontSize: 16,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w800,
      color: Colors.red.shade600,
    ),
    iconTheme: IconThemeData(
      size: 18,
      color: Colors.grey.shade800,
    ),
    colorScheme: ColorScheme.light(),
  );

  int _counter = 0;

  @override
  void initState() {
    super.initState();

    _treeViewController = TreeViewController(children: nodes);
  }

  void _incrementCounter() {
    setState(() {
      _treeViewController = _treeViewController.copyWith(selectedKey: "d3");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 500,
              child: TreeView(
                  controller: _treeViewController,
                  allowParentSelect: true,
                  supportParentDoubleTap: false,
                  //onExpansionChanged: _expandNodeHandler,
                  onNodeTap: (key) {
                    setState(() {
                      _treeViewController = _treeViewController.copyWith(selectedKey: key);
                    });
                  },
                  //theme: _treeViewTheme,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
