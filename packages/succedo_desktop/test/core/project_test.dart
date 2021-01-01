// @dart=2.9
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:succedo_desktop/core/note.dart';
import 'package:succedo_desktop/core/project.dart';
import "package:test/test.dart";
import 'package:uuid/uuid.dart';



void main() {
  test("Should create new project", () async {
    final directory = await Directory.systemTemp.createTemp();
    var path = "${directory.path}/subdir/example.xml";
    var name = "Test project";
    print(path);

    Project.create(title: name, path: path);

    expect(Project.current.title, equals(name));
    expect(Project.current.path, equals(path));
    expect(await File(path).exists(), isTrue);
  });

  test("Should save project with single note", () async {
    final directory = await Directory.systemTemp.createTemp();
    var path = "${directory.path}/subdir/example.xml";
    var name = "Test project";
    Project.create(title: name, path: path);
    Project.current.notes.add(Note(id: Uuid().v4(), title: "Test note"));

    Project.current.save();

    var fileContents = await File(path).readAsString();
    expect(fileContents, equalsIgnoringWhitespace("""
<?xml version="1.0"?>
<project title="Test project">
  <notes>
    <note>
      <title>Test note</title>
    </note>
  </notes>
</project>
    """));
  });

  test("Should save project with nested notes", () async {
    final directory = await Directory.systemTemp.createTemp();
    var path = "${directory.path}/subdir/example.xml";
    var name = "Test project";
    Project.create(title: name, path: path);
    var parentNote = Note(id: Uuid().v4(), title: "Parent note");
    var childNote1 = Note(id: Uuid().v4(), title: "Child note 1");
    var nestedChildNote = Note(id: Uuid().v4(), title: "Nested child note");
    var childNote2 = Note(id: Uuid().v4(), title: "Child note 2");
    parentNote.children.add(childNote1);
    parentNote.children.add(childNote2);
    childNote1.children.add(nestedChildNote);
    Project.current.notes.add(parentNote);

    Project.current.save();

    var fileContents = await File(path).readAsString();
    print(fileContents);
    expect(fileContents, equalsIgnoringWhitespace("""
<?xml version="1.0"?>
<project title="Test project">
  <notes>
    <note>
      <title>Parent note</title>
      <children>
        <note>
          <title>Child note 1</title>
          <children>
            <note>
              <title>Nested child note</title>
            </note>
          </children>
        </note>
        <note>
          <title>Child note 2</title>
        </note>
      </children>
    </note>
  </notes>
</project>
    """));
  });

  test("Should deserialize project with single note", () async {
    var path = "test_resources/test_project_simple.xml";

    var project = Project.load(path: path);

    expect(project.title, equals("Test project"));
    expect(project.notes.getAllNotes().length, equals(1));
    expect(project.notes.getAllNotes()[0].title, equals("Test note"));
    expect(project.notes.getAllNotes()[0].details, equals("Test note details"));
  });

  test("Should deserialize project with nested notes", () async {
    var path = "test_resources/test_project_nested.xml";

    var project = Project.load(path: path);

    expect(project.title, equals("Nested test project"));
    expect(project.notes.getAllNotes().length, equals(1));
    var parentNote = project.notes.getAllNotes()[0];
    expect(parentNote.title, equals("Parent note"));
    expect(parentNote.children.length, equals(2));
    expect(parentNote.children[0].title, equals("Child note 1"));
    expect(parentNote.children[0].children.length, equals(1));
    expect(parentNote.children[0].children[0].title, equals("Nested child note"));
    expect(parentNote.children[0].children[0].children.length, equals(0));
    expect(parentNote.children[1].title, equals("Child note 2"));
    expect(parentNote.children[1].children.length, equals(0));
  });
}
