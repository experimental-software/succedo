// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:succedo_desktop/core/note_repository.dart';
import 'package:succedo_desktop/pages/project_management.dart';

import 'pages/note_overview.dart';

void main(List<String> arguments) {
  GetIt.I.registerSingleton(NoteRepository());

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
      home: ProjectManagementPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
