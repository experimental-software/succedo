// @dart=2.9
import 'package:flutter/material.dart';
import 'package:succedo_desktop/ui/note_overview.dart';

void main(List<String> arguments) {
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
      home: MyHomePage(title: 'Erstellung von Git Workshop Webseite'),
      debugShowCheckedModeBanner: false,
    );
  }
}
