// @dart=2.9
import 'dart:io';

import 'package:succedo/core/config.dart';
import "package:test/test.dart";
import 'package:uuid/uuid.dart';

void main() {

  group("saveLastProject", () {
    test("Should save reference to last project", () async {
      var projectPath = "test_resources/test_project_nested.xml";
      var configPath = "/tmp/${Uuid().v4()}";

      await Config.saveLastProject(projectPath, configPath);

      var fileContents = await File(configPath).readAsString();
      print(fileContents);
      expect(fileContents, contains(projectPath));
    });

    test("Should update reference to last project", () async {
      var configPath = "/tmp/${Uuid().v4()}";
      await File("test_resources/test_config.xml").copy(configPath);

      await Config.saveLastProject("test_resources/test_project_simple.xml", configPath);

      expect(File(configPath).readAsStringSync(), contains("test_resources/test_project_simple.xml"));
    });
  });

  group("loadLastProject", () {
    test("Should load reference to last project", () async {
      var lastProject = await Config.loadLastProject("test_resources/test_config.xml");
      expect(lastProject, equals("test_resources/test_project_nested.xml"));
    });

    test("Should handle no config option", () async {
      var lastProject = await Config.loadLastProject("test_resources/empty_test_config.xml");
      expect(lastProject, isNull);
    });

    test("Should handle no config file", () async {
      var lastProject = await Config.loadLastProject("test_resources/${Uuid().v4()}.xml");
      expect(lastProject, isNull);
    });
  });
  

}

Future<void> _printFile(String filePath) async {
  print("File: $filePath\n");
  print(await File(filePath).readAsString());
}
