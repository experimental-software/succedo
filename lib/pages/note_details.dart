import "package:flutter/material.dart";
import 'package:open_url/open_url.dart';
import "package:succedo/core/note.dart";
import "package:succedo/core/note_repository.dart";

import "../core/project.dart";
import "../widgets/editable_note_title.dart";
import "create_note_dialog.dart";

// TODO: Rename to "TaskDetails"
class NoteDetails extends StatefulWidget {

  // TODO: Rename to "task"
  final Note note;

  NoteDetails(this.note);

  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var noteDetails = widget.note.details;
    if (noteDetails != null) {
      descriptionController.text = noteDetails;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: EditableTitle(
          note: widget.note,
          onTitleChanged: (newTitle) {
            widget.note.title = newTitle;
            Project.current.save();
          },
        ),
      ),
      endDrawer: _buildDrawer(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: TextField(
                  controller: descriptionController,
                  maxLines: 100,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 20),
                  onChanged: (value) {
                    widget.note.details = value;
                    Project.current.save();
                    setState(() {});
                  },
                ),
              ),
            ),
            _ActionButtons(note: widget.note),
            SizedBox(height: 75)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: "Add note",
        child: Icon(Icons.add),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Add task"),
            onTap: () {
              Navigator.of(context).pop();
              _addTask();
            },
          ),
          ListTile(
            title: Text("Add subtask"),
            onTap: () {
              Navigator.of(context).pop();
              _addSubtask();
            },
          ),
          ListTile(
            title: Text("Feedback"),
            onTap: () {
              Navigator.of(context).pop();
              openUrl("https://github.com/experimental-software/succedo/issues/new");
            },
          ),
        ],
      ),
    );
  }
  
  Future<void> _addTask() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateNoteDialog(
          onDialogClose: () {
            Project.current.save();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _addSubtask() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateNoteDialog(
          parent: widget.note,
          onDialogClose: () {
            Project.current.save();
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final NoteRepository noteRepository = Project.current.notes;
  final Note note;

  _ActionButtons({required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 20, 0),
      child: Row(
        children: [
          RaisedButton(
            onPressed: () {
              noteRepository.remove(note);
              Project.current.save();
              Navigator.of(context).pop();
            },
            child: Text("Done"),
          ),
        ],
      ),
    );
  }
}
