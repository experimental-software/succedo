// @dart=2.9
import 'package:flutter/material.dart';
import 'package:succedo_desktop/pages/note_overview.dart';
import 'package:succedo_desktop/pages/project_management.dart';

import 'core/project.dart';

void main(List<String> arguments) {
  Project.load(path: "~/WIP/git-training.xml");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: ProjectManagementPage(),
      home: NoteOverview(initialTitle: Project.current.title),
      debugShowCheckedModeBanner: false,
    );
  }
}
