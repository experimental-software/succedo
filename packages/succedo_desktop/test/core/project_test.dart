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
    Project.current.notes.add(Note(id: "7d4a6cdf-4d30-4f19-a313-afd2a089667e", title: "Test note"));

    Project.current.save();

    var fileContents = await File(path).readAsString();
    print(fileContents);
    expect(fileContents, equalsIgnoringWhitespace("""
<?xml version='1.0'?>
<project title="Test project">
  <notes>
    <note id="7d4a6cdf-4d30-4f19-a313-afd2a089667e">
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
    var parentNote = Note(id: "218f12c9-9fc3-45b9-8a12-a540046f987f", title: "Parent note");
    var childNote1 = Note(id: "79d71496-6799-4212-8247-a93152210410", title: "Child note 1");
    var nestedChildNote = Note(id: "07002cde-0097-4ddc-a685-ca505fafd8e1", title: "Nested child note");
    var childNote2 = Note(id: "07002cde-0097-4ddc-a685-ca505fafd8e1", title: "Child note 2");
    var childNote3 = Note(id: "35ec52b6-6685-4fa3-ae5b-eca95bf11600", title: "Child note 3");
    parentNote.children.add(childNote1);
    parentNote.children.add(childNote2);
    parentNote.children.add(childNote3);
    childNote1.children.add(nestedChildNote);
    Project.current.notes.add(parentNote);

    Project.current.save();

    var fileContents = await File(path).readAsString();
    print(fileContents);
    expect(fileContents, equalsIgnoringWhitespace("""
<?xml version='1.0'?>
<project title="Test project">
  <notes>
    <note id="218f12c9-9fc3-45b9-8a12-a540046f987f">
      <title>Parent note</title>
      <children>
        <note id="79d71496-6799-4212-8247-a93152210410">
          <title>Child note 1</title>
          <children>
            <note id="07002cde-0097-4ddc-a685-ca505fafd8e1">
              <title>Nested child note</title>
            </note>
          </children>
        </note>
        <note id="07002cde-0097-4ddc-a685-ca505fafd8e1">
          <title>Child note 2</title>
        </note>
        <note id="35ec52b6-6685-4fa3-ae5b-eca95bf11600">
          <title>Child note 3</title>
        </note>
      </children>
    </note>
  </notes>
</project>
    """));
  });

  test("Should deserialize project with single note", () {
    var path = "test_resources/test_project_simple.xml";

    var project = Project.load(path: path);

    expect(project.title, equals("Test project"));
    expect(project.notes.getRootNotes().length, equals(1));
    expect(project.notes.getRootNotes()[0].title, equals("Test note"));
    expect(project.notes.getRootNotes()[0].details, equals("Test note details"));
  });

  test("Should deserialize project with nested notes", () {
    var path = "test_resources/test_project_nested.xml";

    var project = Project.load(path: path);

    expect(project.title, equals("Nested test project"));
    expect(project.notes.getRootNotes().length, equals(1));
    var parentNote = project.notes.getRootNotes()[0];
    expect(parentNote.title, equals("Parent note"));
    expect(parentNote.children.length, equals(3));
    expect(parentNote.children[0].title, equals("Child note 1"));
    expect(parentNote.children[0].children.length, equals(1));
    expect(parentNote.children[0].children[0].title, equals("Nested child note"));
    expect(parentNote.children[0].children[0].children.length, equals(0));
    expect(parentNote.children[1].title, equals("Child note 2"));
    expect(parentNote.children[1].children.length, equals(0));
  });

  test("Should move root note up", () {
    var path = "test_resources/test_project_multiple_root_notes.xml";
    var project = Project.load(path: path);
    var noteToBeMoved = project.notes.getRootNotes()[2];

    project.decrementIndex(noteToBeMoved);

    expect(project.notes.getRootNotes()[1], equals(noteToBeMoved));
    expect(project.notes.getRootNotes().length, equals(3));
  });

  test("Should move root note down", () {
    var path = "test_resources/test_project_multiple_root_notes.xml";
    var project = Project.load(path: path);
    var noteToBeMoved = project.notes.getRootNotes()[0];

    project.incrementIndex(noteToBeMoved);

    expect(project.notes.getRootNotes()[1], equals(noteToBeMoved));
    expect(project.notes.getRootNotes().length, equals(3));
  });

  test("Should move child note up", () {
    var projectPath = "test_resources/test_project_nested.xml";
    var project = Project.load(path: projectPath);
    var noteToBeMoved = project.notes.getRootNotes()[0].children[1];

    project.decrementIndex(noteToBeMoved);

    expect(project.notes.getRootNotes()[0].children[0], equals(noteToBeMoved));
  });
}
