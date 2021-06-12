import 'package:flutter/material.dart';
import 'package:succedo/core/task.dart';

class EditableTitle extends StatefulWidget {
  final Task task;
  final Function onTitleChanged;

  EditableTitle({required this.task, required this.onTitleChanged});

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

    titleController.text = widget.task.title;
  }

  String _displayedTitle() {
    var ancestorTitles = widget.task.ancestors.reversed.map((e) => e.title + " > ").toList();
    var result = "";
    for (var ancestorTitle in ancestorTitles) {
      result += ancestorTitle;
    }
    result += widget.task.title;
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
              widget.task.title = value;
            }
            onTitleChanged(widget.task.title);
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
