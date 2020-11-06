import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddNotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notiz hinzufügen"),
      ),
      body: Column(
        children: [
          _actionButtons(context),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Abbrechen'),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
                tasks
                    .add({"title": "${DateTime.now().toIso8601String()}", "details": "Hallo, Welt!", "position": null})
                    .then((value) => print("Task added"))
                    .catchError((error) => print("Failed to add task: $error"));
              },
              child: Text('Speichern'),
            ),
          ),
        )
      ],
    );
  }
}
