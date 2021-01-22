import "dart:io";

import "package:path/path.dart";
import "package:xml/xml.dart";


class Config {

  static Future<void> saveLastProject(String lastProjectPath, String configFilePath) async {
    if (await File(configFilePath).exists()) {
      // TODO Save last project into existing config file.
      throw "No support for loading existing config file, yet.";
    } else {
      var file = _buildFile(configFilePath);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      final builder = XmlBuilder();
      builder.processing("xml", "version='1.0'");
      builder.element("config", nest: () {
        builder.element("lastProject", nest: () {
          builder.text(lastProjectPath);
        });
      });
      final projectXml = builder.buildDocument();

      var sink = file.openWrite();
      sink.write(projectXml.toXmlString(pretty: true));
      sink.close();
    }
  }

  static Future<String?> loadLastProject(String configFilePath) async {
    var file = _buildFile(configFilePath);
    if (!file.existsSync()) {
      return Future.value(null);
    }
    var fileContents = await file.readAsString();
    var document = XmlDocument.parse(fileContents);
    var configNode = document.getElement("config");
    if (configNode == null) {
      return Future.value(null);
    }
    var lastProjectNode = configNode.getElement("lastProject");
    if (lastProjectNode == null) {
      return Future.value(null);
    }
    var lastProject = lastProjectNode.innerText;
    if (lastProject.isEmpty) {
      return Future.value(null);
    }
    return lastProject;
  }

  static File _buildFile(String path) {
    var normalizedPath = path
        .replaceAll("~", absolute(Platform.environment["HOME"]!) + "/")
    // As workaround for https://github.com/flutter/flutter/issues/68713, "*" is used as synonym for "~".
        .replaceAll("*", absolute(Platform.environment["HOME"]!) + "/");
    return File(normalizedPath);
  }
}
