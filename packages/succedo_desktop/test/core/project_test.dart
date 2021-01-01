// @dart=2.9
import 'dart:io';

import 'package:succedo_desktop/core/project.dart';
import "package:test/test.dart";



void main() {
  test("Should create new project", () async {
    final directory = await Directory.systemTemp.createTemp();
    var path = "${directory.path}/example.xml"; // TODO What if there is a nonexistent subdirectory?
    var name = "Test project";

    Project.create(name: name, path: path);

    expect(Project.current.path, equals("${directory.path}/example.xml"));
  });

  test("String.trim() removes surrounding whitespace", () {
    var string = "  foo ";
    expect(string.trim(), equals("foo"));
  });
}