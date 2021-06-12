import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:succedo/pages/task_overview.dart';

import '../core/project.dart';
import '../routing.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Succedo"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 500,
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50),
                // TODO Replace usage of deprecated "RaisedButton"
                RaisedButton(
                  child: Text("Create new project"),
                  onPressed: () => showCreateProjectDialog(context),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  child: Text("Open existing project"),
                  onPressed: () => showOpenExistingProjectDialog(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future showCreateProjectDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _CreateProjectDialog(
        onDialogClose: (Project? project) {
          Navigator.pop(context);
          if (project != null) {
            Navigator.push(
              context,
              DesktopPageRoute(builder: (context) {
                return TaskOverview(initialTitle: project.title);
              }),
            );
          }
        },
      );
    },
  );
}

Future showOpenExistingProjectDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _OpenProjectDialog(
        onDialogClose: (Project? project) {
          Navigator.pop(context);
          if (project != null) {
            Navigator.push(
              context,
              DesktopPageRoute(builder: (context) {
                return TaskOverview(initialTitle: project.title);
              }),
            );
          }
        },
      );
    },
  );
}

class _OpenProjectDialog extends StatefulWidget {
  final Function onDialogClose;

  _OpenProjectDialog({required this.onDialogClose});

  @override
  _OpenProjectDialogState createState() => _OpenProjectDialogState();
}

class _OpenProjectDialogState extends State<_OpenProjectDialog> {
  final formKey = GlobalKey<FormState>();
  final projectPathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SimpleDialog(
        title: Text("Open project"),
        children: [
          Container(
            height: 500,
            width: 800,
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
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
                SizedBox(height: 20),
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
                        "Okay",
                        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      onPressed: okay,
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void okay() {
    var formState = formKey.currentState;
    if (formState != null) {
      if (!formState.validate()) {
        return;
      }
    }

    var path = projectPathController.text;
    var project = Project.load(path: path);
    widget.onDialogClose(project);
  }

  void cancel() {
    widget.onDialogClose(null);
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
