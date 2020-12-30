
import 'package:flutter/material.dart';
import 'package:succedo_desktop/core/note.dart';

class NoteDetails extends StatefulWidget {

  final Note note;

  NoteDetails(this.note);

  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title),
      ),
      body: Center(
        child: Text(widget.note.description ?? ""),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("add note!"),
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }
}
