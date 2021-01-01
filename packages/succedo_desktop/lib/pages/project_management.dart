import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:succedo_desktop/pages/note_overview.dart';

import '../core/project.dart';
import '../routing.dart';

class ProjectManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project management"),
      ),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _CreateProjectDialog(
                    onDialogClose: (Project? project) {
                      Navigator.pop(context);
                      if (project != null) {
                        Navigator.push(
                          context,
                          DesktopPageRoute(builder: (context) {
                            return NoteOverview(initialTitle: project.title);
                          }),
                        );
                      }
                    },
                  );
                },
              );
            },
            child: Text("Create new project"),
          )
        ],
      ),
    );
  }
}

class _CreateProjectDialog extends StatefulWidget {
  final Function onDialogClose;

  _CreateProjectDialog({required this.onDialogClose});

  @override
  _CreateProjectDialogState createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<_CreateProjectDialog> {
  final formKey = GlobalKey<FormState>();
  final projectNameController = TextEditingController();
  final projectPathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SimpleDialog(
        title: Text("Create project"),
        children: [
          Container(
            height: 600,
            width: 800,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: projectNameController,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Must not be empty.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Name*",
                    border: const OutlineInputBorder(),
                    helperText: "* Required",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: projectPathController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Must not be empty.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Path*",
                    border: const OutlineInputBorder(),
                    helperText: "* Required",
                  ),
                ),
                SizedBox(height: 100),
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
        ],
      ),
    );
  }

  void save() {
    var formState = formKey.currentState;
    if (formState != null) {
      if (!formState.validate()) {
        return;
      }
    }

    var project = Project.create(
      title: projectNameController.text,
      path: projectPathController.text,
    );
    widget.onDialogClose(project);
  }

  void cancel() {
    widget.onDialogClose(null);
  }
}
