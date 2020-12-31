import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:get_it/get_it.dart';
import 'package:succedo_desktop/core/note.dart';
import 'package:succedo_desktop/core/note_repository.dart';
import 'package:succedo_desktop/routing.dart';
import 'package:succedo_desktop/ui/create_note_dialog.dart';
import 'package:succedo_desktop/ui/note_details.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NoteRepository noteRepository = GetIt.I.get<NoteRepository>();
  FocusNode keyboardFocus = FocusNode();

  late TreeViewController treeViewController;

  @override
  void initState() {
    super.initState();
    treeViewController = TreeViewController(children: _toNodes(noteRepository.getAllNotes()));
  }

  @override
  void dispose() {
    keyboardFocus.dispose();
    super.dispose();
  }

  void _addNote() async {
    keyboardFocus.unfocus();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateNoteDialog(
          onDialogClose: () => Navigator.pop(context),
        );
      },
    );
    keyboardFocus.requestFocus();

    setState(() {
      treeViewController = TreeViewController(children: _toNodes(noteRepository.getAllNotes()));
    });
  }

  @override
  Widget build(BuildContext context) {
    keyboardFocus.requestFocus();
    return RawKeyboardListener(
      focusNode: keyboardFocus,
      autofocus: true,
      onKey: handleKeyPressed,
      child: Scaffold(
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
                  controller: treeViewController,
                  allowParentSelect: true,
                  supportParentDoubleTap: false,
                  onNodeTap: (key) {
                    if (key == treeViewController.selectedKey) {
                      var note = noteRepository.findNote(key);
                      if (note == null) {
                        // TODO: An alert dialog would be nice here.
                        print("[WARNING] Note '$key' not found.");
                        return;
                      }
                      keyboardFocus.unfocus();
                      Navigator.push(
                        context,
                        DesktopPageRoute(builder: (context) {
                          return NoteDetails(note);
                        }),
                      ).then((_) {
                        keyboardFocus.requestFocus();
                        setState(() {
                          treeViewController = TreeViewController(children: _toNodes(noteRepository.getAllNotes()));
                        });
                      });
                    } else {
                      setState(() {
                        treeViewController = treeViewController.copyWith(selectedKey: key);
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
      ),
    );
  }

  void handleKeyPressed(event) {
    var selectedKey = treeViewController.selectedKey;
    if (selectedKey != null) {
      var selectedNote = noteRepository.findNote(selectedKey);

    }
    var character = event.character;
    if (character != null) {
      print("Key pressed: $character");
    }
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
