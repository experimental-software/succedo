import 'package:flutter/material.dart';

class EditableTitle extends StatefulWidget {
  final String initialTitle;
  final Function onTitleChanged;

  EditableTitle({required this.initialTitle, required this.onTitleChanged});

  @override
  _EditableTitleState createState() => _EditableTitleState(onTitleChanged: onTitleChanged);
}

class _EditableTitleState extends State<EditableTitle> {
  final titleController = TextEditingController();
  final Function onTitleChanged;

  late String title;
  bool editMode = false;

  _EditableTitleState({required this.onTitleChanged});

  @override
  void initState() {
    super.initState();

    title = widget.initialTitle;
    titleController.text = widget.initialTitle;
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
              title = value;
            }
            onTitleChanged(title);
            setState(() {
              editMode = false;
            });
          },
        ),
      );
    } else {
      assert(debugCheckHasMaterial(context));
      return InkWell(
        child: Text(title),
        onTap: () {
          setState(() {
            editMode = true;
          });
        },
      );
    }
  }
}