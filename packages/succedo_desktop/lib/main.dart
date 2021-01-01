// @dart=2.9
import 'package:flutter/material.dart';
import 'package:succedo_desktop/core/note_repository.dart';
import 'package:succedo_desktop/screens/note_overview.dart';
import 'package:get_it/get_it.dart';

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
      home: NoteOverview(initialTitle: 'Erstellung von Git Workshop Webseite'),
      debugShowCheckedModeBanner: false,
    );
  }
}
