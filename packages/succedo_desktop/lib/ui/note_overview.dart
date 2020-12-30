import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:succedo_desktop/core/note.dart';
import 'package:succedo_desktop/core/note_repository.dart';
import 'package:succedo_desktop/routing.dart';
import 'package:succedo_desktop/ui/create_note_dialog.dart';
import 'package:succedo_desktop/ui/note_details.dart';
import 'package:uuid/uuid.dart';

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

  void _addNote() async {
    Note? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateNoteDialog(
          onDialogClose: (result) => Navigator.pop(context, result),
        );
      },
    );

    if (result != null) {
      var node = _toNode(Note(
        id: Uuid().v4(),
        title: result.title,
        description: result.description,
      ));
      setState(() {
        _treeViewController.children.add(node);
      });
    }
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
                onNodeTap: (key) {
                  if (key == _treeViewController.selectedKey) {
                    Navigator.push(
                      context,
                      DesktopPageRoute(builder: (context) => NoteDetails(noteRepository.findNote(key)!)),
                    );
                  } else {
                    setState(() {
                      _treeViewController = _treeViewController.copyWith(selectedKey: key);
                    });
                  }

                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add note',
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

Node _toNode(Note note) {
  return Node(
    key: note.id,
    label: note.title,
    icon: NodeIcon.fromIconData(Icons.build),
    children: _toNodes(note.children),
  );
}
