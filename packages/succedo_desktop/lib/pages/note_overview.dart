import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:open_url/open_url.dart';
import 'package:succedo_desktop/core/note.dart';
import 'package:succedo_desktop/core/note_repository.dart';
import 'package:succedo_desktop/routing.dart';

import '../widgets/editable_title.dart';
import 'create_note_dialog.dart';
import 'note_details.dart';
import '../core/project.dart';
import 'project_management.dart';

class NoteOverview extends StatefulWidget {
  NoteOverview({required this.initialTitle});

  final String initialTitle;

  @override
  _NoteOverviewState createState() => _NoteOverviewState();
}

class _NoteOverviewState extends State<NoteOverview> {
  NoteRepository noteRepository = Project.current.notes;
  FocusNode keyboardFocus = FocusNode();
  Note? noteInTray;

  late TreeViewController treeViewController;

  @override
  void initState() {
    super.initState();
    treeViewController = TreeViewController(children: _toNodes(noteRepository.getRootNotes()));
  }

  @override
  void dispose() {
    keyboardFocus.dispose();
    super.dispose();
  }

  void _addNote() async {
    Note? parent;
    var selectedKey = treeViewController.selectedKey;
    // ignore: unnecessary_null_comparison
    if (selectedKey != null) {
      parent = noteRepository.findNote(selectedKey)!;
    }

    keyboardFocus.unfocus();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateNoteDialog(
          parent: parent,
          onDialogClose: () => Navigator.pop(context),
        );
      },
    );
    keyboardFocus.requestFocus();

    updateTreeView();
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
          title: EditableTitle(
            initialTitle: widget.initialTitle,
            onTitleChanged: (newTitle) {
              var project = Project.current;
              project.title = newTitle;
              project.save();
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TreeView(
                  controller: treeViewController,
                  allowParentSelect: true,
                  supportParentDoubleTap: false,
                  onNodeTap: (key) {
                    if (key == treeViewController.selectedKey) {
                      var note = noteRepository.findNote(key);
                      if (note == null) {
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
                        updateTreeView();
                      });
                    } else {
                      setState(() {
                        treeViewController = treeViewController.copyWith(selectedKey: key);
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Text("Feedback"),
                  onTap: () => openUrl("https://github.com/experimental-software/succedo/issues/new"),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNote,
          tooltip: 'Add note',
          child: Icon(Icons.add),
        ),
        endDrawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text("Create new project"),
                onTap: () => showCreateProjectDialog(context),
              ),
              ListTile(
                title: Text("Open existing project"),
                onTap: () => showOpenExistingProjectDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateTreeView() {
    setState(() {
      treeViewController = TreeViewController(children: _toNodes(noteRepository.getRootNotes()));
    });
  }

  void handleKeyPressed(RawKeyEvent event) {
    var selectedKey = treeViewController.selectedKey;
    // ignore: unnecessary_null_comparison
    if (selectedKey != null) {
      var selectedNote = noteRepository.findNote(selectedKey)!;

      if (event.data.physicalKey == PhysicalKeyboardKey.escape) {
        treeViewController = treeViewController.copyWith(selectedKey: null);
        updateTreeView();
        return;
      }

      if (event.isControlOrCommandPressed && event.data.keyLabel == "x") {
        noteInTray = selectedNote;
        noteRepository.remove(selectedNote);
        treeViewController = treeViewController.copyWith(selectedKey: null);
        updateTreeView();
        return;
      }
      if (event.isControlOrCommandPressed && event.data.keyLabel == "v" && noteInTray != null) {
        noteRepository.registerChild(noteInTray!, selectedNote.id);
        noteInTray = null;
        updateTreeView();
        return;
      }
      if (event.isControlOrCommandPressed && event.isShiftPressed && event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
        Project.current.decrementIndex(selectedNote);
        setState(() {
          treeViewController = TreeViewController(
            children: _toNodes(noteRepository.getRootNotes()),
            selectedKey: selectedNote.id,
          );
        });
        return;
      }
      if (event.isControlOrCommandPressed && event.isShiftPressed && event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
        Project.current.incrementIndex(selectedNote);
        setState(() {
          treeViewController = TreeViewController(
            children: _toNodes(noteRepository.getRootNotes()),
            selectedKey: selectedNote.id,
          );
        });
        return;
      }
    } else {
      if (event.isControlOrCommandPressed && event.character == "v" && noteInTray != null) {
        noteRepository.registerChild(noteInTray!, null);
        noteInTray = null;
        updateTreeView();
        return;
      }
    }
  }
}

extension _CustomEventQueries on RawKeyEvent {
  bool get isControlOrCommandPressed {
    if (Platform.isMacOS) {
      return isMetaPressed;
    } else {
      return isControlPressed;
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
