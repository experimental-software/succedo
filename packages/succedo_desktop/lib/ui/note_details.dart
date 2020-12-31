import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';
import 'package:succedo_desktop/core/note.dart';
import 'package:succedo_desktop/core/note_repository.dart';
import 'package:succedo_desktop/ui/create_note_dialog.dart';

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
        child: Column(
          children: [
            _ActionButtons(note: widget.note),
            Expanded(
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
          onDialogClose: () => Navigator.pop(context),
        );
      },
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final NoteRepository noteRepository = GetIt.I.get<NoteRepository>();
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
              Navigator.of(context).pop();
            },
            child: Text("Erledigt"),
          )
        ],
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
