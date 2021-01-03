// @dart=2.9
import 'package:flutter/material.dart';
import 'package:succedo_desktop/pages/note_overview.dart';
import 'package:succedo_desktop/pages/project_management.dart';

import 'core/project.dart';

void main(List<String> arguments) {
  String projectPath;
  if (arguments.length == 1) projectPath = arguments[0];

  runApp(SuccedoApp(
    initialProjectPath: projectPath,
  ));
}

class SuccedoApp extends StatefulWidget {
  final String initialProjectPath;

  SuccedoApp({this.initialProjectPath});

  @override
  _SuccedoAppState createState() => _SuccedoAppState();
}

class _SuccedoAppState extends State<SuccedoApp> {
  @override
  void initState() {
    super.initState();
    if (widget.initialProjectPath != null) {
      Project.load(path: widget.initialProjectPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: ProjectManagementPage(),
      home: _homePage(),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _homePage() {
    if (widget.initialProjectPath == null) {
      return ProjectManagementPage();
    } else {
      return NoteOverview(initialTitle: Project.current.title);
    }
  }
}
