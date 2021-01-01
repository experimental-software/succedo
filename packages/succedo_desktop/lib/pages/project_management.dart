import 'package:flutter/material.dart';

class ProjectManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project management"),
      ),
      body: Column(children: [
        RaisedButton(
          onPressed: () {
            print("TODO: Create new project");
          },
          child: Text("Create new project"),
        )
      ],),
    );
  }
}
