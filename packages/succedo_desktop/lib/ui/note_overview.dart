import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:succedo_desktop/core/note.dart';
import 'package:succedo_desktop/core/note_repository.dart';
import 'package:succedo_desktop/routing.dart';
import 'package:succedo_desktop/ui/create_note_dialog.dart';
import 'package:succedo_desktop/ui/note_details.dart';
import 'package:get_it/get_it.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NoteRepository noteRepository = GetIt.I.get<NoteRepository>();

  late TreeViewController _treeViewController;

  @override
  void initState() {
    super.initState();

    _treeViewController = TreeViewController(children: _toNodes(noteRepository.getAllNotes()));
  }

  void _addNote() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateNoteDialog(
          onDialogClose: () => Navigator.pop(context),
        );
      },
    );

    setState(() {
      _treeViewController = TreeViewController(children: _toNodes(noteRepository.getAllNotes()));
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
                onNodeTap: (key) {
                  if (key == _treeViewController.selectedKey) {
                    var note = noteRepository.findNote(key);
                    if (note == null) {
                      // TODO: An alert dialog would be nice here.
                      print("[WARNING] Note '$key' not found.");
                      return;
                    }
                    Navigator.push(
                      context,
                      DesktopPageRoute(builder: (context) {
                        return NoteDetails(note);
                      }),
                    ).then((value) {
                      setState(() {
                        _treeViewController = TreeViewController(children: _toNodes(noteRepository.getAllNotes()));
                      });
                    });
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
