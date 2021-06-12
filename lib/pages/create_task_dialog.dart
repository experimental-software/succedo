import 'package:flutter/material.dart';
import 'package:succedo/core/task.dart';
import 'package:succedo/core/task_repository.dart';
import 'package:succedo/core/project.dart';
import 'package:succedo/util/test_bench.dart';
import 'package:uuid/uuid.dart';

import '../core/project.dart';

class CreateTaskDialog extends StatefulWidget {
  final Function onDialogClose;
  final Task? parent;

  CreateTaskDialog({required this.onDialogClose, this.parent});

  @override
  _CreateTaskDialogState createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TaskRepository taskRepository = Project.current.tasks;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Create task"),
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
                        return "The task title must not be empty.";
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
        var task = Task(
          id: Uuid().v4(),
          title: titleController.text,
          details: detailsController.text,
        );
        if (widget.parent != null) {
          taskRepository.registerChild(task, widget.parent!.id);
        } else {
          taskRepository.add(task);
        }
        Project.current.save();
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
      child: CreateTaskDialog(
        onDialogClose: (task) => print(task),
      ),
    ),
  );
}
