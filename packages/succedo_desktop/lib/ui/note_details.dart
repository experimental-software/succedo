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
        title: Text(widget.note.title),
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
                  setState(() {

                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Markdown(
                data: descriptionController.text,
                selectable: true,
              ),
              //color: Colors.teal[200],

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
