import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:succedo_desktop/core/note.dart';
import 'package:succedo_desktop/core/note_repository.dart';
import 'package:succedo_desktop/util/test_bench.dart';
import 'package:uuid/uuid.dart';

class CreateNoteDialog extends StatefulWidget {
  final Function onDialogClose;
  final Note? parent;

  CreateNoteDialog({required this.onDialogClose, this.parent});

  @override
  _CreateNoteDialogState createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<CreateNoteDialog> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final NoteRepository noteRepository = GetIt.I.get<NoteRepository>();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Create note"),
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints.tight(Size(800, 400)),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "The note title must not be empty.";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Title*",
                      border: const OutlineInputBorder(),
                      helperText: "* Required",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: detailsController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RaisedButton(
                        child: Text("Cancel"),
                        onPressed: cancel,
                      ),
                      SizedBox(width: 10),
                      RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "Save",
                          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                        ),
                        onPressed: save,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void save() {
    var currentState = formKey.currentState;
    if (currentState != null) {
      if (currentState.validate()) {
        var note = Note(
          id: Uuid().v4(),
          title: titleController.text,
          details: detailsController.text,
        );
        if (widget.parent != null) {
          noteRepository.registerChild(note, widget.parent!.id);
        } else {
          noteRepository.add(note);
        }
        widget.onDialogClose();
      }
    }
  }

  void cancel() {
    widget.onDialogClose();
  }
}

void main() {
  runApp(
    TestBench(
      child: CreateNoteDialog(
        onDialogClose: (note) => print(note),
      ),
    ),
  );
}
