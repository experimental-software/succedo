import 'package:flutter/material.dart';
import 'package:succedo/core/note.dart';

class EditableTitle extends StatefulWidget {
  final Note note;
  final Function onTitleChanged;

  EditableTitle({required this.note, required this.onTitleChanged});

  @override
  _EditableTitleState createState() => _EditableTitleState(onTitleChanged: onTitleChanged);
}

class _EditableTitleState extends State<EditableTitle> {
  final titleController = TextEditingController();
  final Function onTitleChanged;

  bool editMode = false;

  _EditableTitleState({required this.onTitleChanged});

  @override
  void initState() {
    super.initState();

    titleController.text = widget.note.title;
  }

  String _displayedTitle() {
    var ancestorTitles = widget.note.ancestors.reversed.map((e) => e.title + " > ").toList();
    var result = "";
    for (var ancestorTitle in ancestorTitles) {
      result += ancestorTitle;
    }
    result += widget.note.title;
    return result;
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
            onTitleChanged(widget.note.title);
            setState(() {
              editMode = false;
            });
          },
        ),
      );
    } else {
      assert(debugCheckHasMaterial(context));
      return InkWell(
        child: Text(_displayedTitle()),
        onTap: () {
          setState(() {
            editMode = true;
          });
        },
      );
    }
  }
}
