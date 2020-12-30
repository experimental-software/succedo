import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
        title: _NoteTitle(widget.note),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: descriptionController,
                maxLines: 100,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  widget.note.details = value;
                  setState(() {});
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Markdown(
                data: descriptionController.text,
                selectable: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("add note!"),
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }
}

class _NoteTitle extends StatefulWidget {
  final Note note;

  _NoteTitle(this.note);

  @override
  _NoteTitleState createState() => _NoteTitleState();
}

class _NoteTitleState extends State<_NoteTitle> {

  final titleController = TextEditingController();

  bool editMode = false;

  @override
  void initState() {
    super.initState();

    titleController.text = widget.note.title;
  }

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      return Container(
        color: Colors.white,
        child: TextField(
          controller: titleController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              widget.note.title = value;
            }
            setState(() {
              editMode = false;
            });
          },
        ),
      );
    } else {
      assert(debugCheckHasMaterial(context));
      return InkWell(
        child: Text(widget.note.title),
        onTap: () {
          setState(() {
            editMode = true;
          });
        },
      );
    }
  }
}
