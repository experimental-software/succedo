import "dart:io";

import "package:path/path.dart";
import "package:xml/xml.dart";


class Config {

  static Future<void> saveLastProject(String lastProjectPath, [String configFilePath = "~/.succedo"]) async {
    lastProjectPath = lastProjectPath.replaceAll("~", absolute(Platform.environment["HOME"]!) + "/");
    if (await _buildFile(configFilePath).exists()) {
      var configDocument = (await _loadConfig(configFilePath))!;

      var configNode = configDocument.getElement("config");
      if (configNode == null) {
        throw "Could not find 'config' node";
      }
      var lastProjectNode = configNode.getElement("lastProject");
      if (lastProjectNode == null) {
        throw "Could not find 'lastProject' node.";
      }
      lastProjectNode.innerText = lastProjectPath;

      var configFileContents = configDocument.toXmlString(pretty: true, preserveWhitespace: (_) => true);
      var file = _buildFile(configFilePath);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      print("[INFO] Saving config to ${file.path}");
      var sink = file.openWrite(mode: FileMode.writeOnly);
      sink.write(configFileContents);
      await sink.close();
    } else {
      _createNewConfig(lastProjectPath, configFilePath);
    }
  }

  static Future<void> _createNewConfig(String lastProjectPath, String configFilePath) async {
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
    sink.write(projectXml.toXmlString(pretty: true, preserveWhitespace: (_) => true));
    sink.close();
  }

  static Future<XmlDocument?> _loadConfig(String configFilePath) async {
    var file = _buildFile(configFilePath);
    if (!file.existsSync()) {
      return null;
    }
    var fileContents = await file.readAsString();
    return XmlDocument.parse(fileContents);
  }

  static Future<String?> loadLastProject(String configFilePath) async {
    var configDocument = await _loadConfig(configFilePath);
    if (configDocument == null) {
      return null;
    }
    var configNode = configDocument.getElement("config");
    if (configNode == null) {
      return null;
    }
    var lastProjectNode = configNode.getElement("lastProject");
    if (lastProjectNode == null) {
      return null;
    }
    var lastProject = lastProjectNode.innerText;
    if (lastProject.isEmpty) {
      return null;
    }
    if (!File(lastProject).existsSync()) {
      return null;
    }
    return lastProject;
  }

  static File _buildFile(String path) {
    var normalizedPath = path
        .replaceAll("~", absolute(Platform.environment["HOME"]!) + "/");
    return File(normalizedPath);
  }
}
