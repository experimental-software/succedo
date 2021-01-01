// @dart=2.9
import 'dart:io';

import 'package:succedo_desktop/core/project.dart';
import "package:test/test.dart";



void main() {
  test("Should create new project", () async {
    final directory = await Directory.systemTemp.createTemp();
    var path = "${directory.path}/subdir/example.xml"; // TODO What if there is a nonexistent subdirectory?
    var name = "Test project";
    print(path);

    Project.create(name: name, path: path);

    expect(Project.current.name, equals(name));
    expect(Project.current.path, equals(path));
    expect(await File(path).exists(), isTrue);
  });

  test("String.trim() removes surrounding whitespace", () {
    var string = "  foo ";
    expect(string.trim(), equals("foo"));
  });
}