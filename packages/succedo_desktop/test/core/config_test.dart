// @dart=2.9
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:succedo_desktop/core/config.dart';
import 'package:succedo_desktop/core/note.dart';
import 'package:succedo_desktop/core/project.dart';
import "package:test/test.dart";
import 'package:uuid/uuid.dart';

void main() {

  test("Should save reference to last project", () async {
    var projectPath = "test_resources/test_project_nested.xml";
    var configFilePath = "/tmp/${Uuid().v4()}";

    await Config.saveLastProject(projectPath, configFilePath);

    var fileContents = await File(configFilePath).readAsString();
    print(fileContents);
    expect(fileContents, contains(projectPath));
  });

  test("Should load reference to last project", () async {
    var lastProject = await Config.loadLastProject("test_resources/test_config.xml");
    expect(lastProject, equals("test_resources/test_project_nested.xml"));
  });

  // TODO use nested tests
  test("Should handle no config option", () async {
    var lastProject = await Config.loadLastProject("test_resources/empty_test_config.xml");
    expect(lastProject, isNull);
  });

  test("Should handle no config file", () async {
    var lastProject = await Config.loadLastProject("test_resources/${Uuid().v4()}.xml");
    expect(lastProject, isNull);
  });
}
