import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:succedo_desktop/core/note.dart';
import 'package:succedo_desktop/core/note_repository.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NoteRepository noteRepository = NoteRepository();

  late TreeViewController _treeViewController;
  late List<Node> _nodes;

  @override
  void initState() {
    super.initState();

    _nodes = _toNodes(noteRepository.getAllNotes());
    _treeViewController = TreeViewController(children: _nodes);

  }

  void _incrementCounter() {
    setState(() {
      //_treeViewController = _treeViewController.copyWith(selectedKey: "d3");
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

List<Node> _toNodes(List<Note> notes) {
  List<Node> result = [];
  for (Note note in notes) {
    Node node = Node(
      label: note.title,
      key: note.id,
      icon: NodeIcon.fromIconData(Icons.build),
      children: _toNodes(note.children),
    );
    result.add(node);
  }
  return result;
}
