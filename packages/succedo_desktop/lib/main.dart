// @dart=2.9
import 'package:flutter/material.dart';
import 'package:succedo_desktop/pages/project_management.dart';

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
      home: ProjectManagementPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
