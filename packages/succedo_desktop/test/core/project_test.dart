// @dart=2.9
import 'dart:io';

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

    Project.create(name: name, path: path);

    expect(Project.current.name, equals(name));
    expect(Project.current.path, equals(path));
    expect(await File(path).exists(), isTrue);
  });

  test("Should save tasks in project", () async {
    final directory = await Directory.systemTemp.createTemp();
    var path = "${directory.path}/subdir/example.xml";
    var name = "Test project";
    Project.create(name: name, path: path);
    Project.current.notes.add(Note(id: Uuid().v4(), title: "Test note"));

    Project.current.save();

    var fileContents = await File(path).readAsString();
    print(fileContents);
    expect(fileContents, isNotEmpty);
  });

  test("String.trim() removes surrounding whitespace", () {
    var string = "  foo ";
    expect(string.trim(), equals("foo"));
  });
}