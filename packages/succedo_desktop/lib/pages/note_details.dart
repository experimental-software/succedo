import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:succedo_desktop/core/note.dart';
import 'package:succedo_desktop/core/note_repository.dart';

import '../widgets/editable_title.dart';
import 'create_note_dialog.dart';
import '../core/project.dart';

class NoteDetails extends StatefulWidget {
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
        title: EditableTitle(
          initialTitle: widget.note.title,
          onTitleChanged: (newTitle) {
            widget.note.title = newTitle;
            Project.current.save();
          },
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            _ActionButtons(note: widget.note),
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
            SizedBox(height: 75)
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

  void _addNote() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateNoteDialog(
          onDialogClose: () {
            Project.current.save(); // TODO More generic handling for saving. Maybe add a save icon.
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
