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
    var path = "test_resources/test-project-simple.xml";

    var project = Project.load(path: path);

    expect(project.title, equals("Test project"));
  });
}
