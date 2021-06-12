import "dart:io";

import "package:path/path.dart";
import "package:succedo/core/task_repository.dart";
import "package:xml/xml.dart";

import "task.dart";
import 'config.dart';

// TODO Migrate project files from "note" to "task"
class Project {
  static Project? _current;

  late String title;
  late String path;
  late TaskRepository tasks;

  Project({required this.title, required this.path});

  Project.create({required this.title, required this.path}) {
    tasks = TaskRepository.empty();
    save();

    _current = this;
    Config.saveLastProject(path);
  }

  Project.load({required this.path}) {
    tasks = TaskRepository.empty();
    var file = _buildFile(path);
    if (!file.existsSync()) {
      throw "File with path ${file.absolute.path} does not exist.";
    }
    print("[INFO] Loading project from path ${file.path}");
    var fileContents = file.readAsStringSync();
    var document = XmlDocument.parse(fileContents);
    var projectNode = document.getElement("project");
    title = projectNode!.getAttribute("title")!;
    var notesXml = projectNode.getElement("notes");
    if (notesXml != null) {
      for (var noteXml in notesXml.findElements("note")) {
        tasks.append(_deserializeNote(noteXml));
      }
    }

    _current = this;

    Config.saveLastProject(path);
  }

  static Project get current {
    return _current!;
  }

  Future save() async {
    print("[INFO] Saving project to path $path");
    var file = _buildFile(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    final builder = XmlBuilder();
    builder.processing("xml", "version='1.0'");
    builder.element("project", nest: () {
      builder.attribute("title", title);

      builder.element("notes", nest: () {
        for (var note in tasks.getRootTasks()) {
          _addNote(builder, note);
        }
      });
    });
    final projectXml = builder.buildDocument();

    var sink = file.openWrite();
    sink.write(projectXml.toXmlString(pretty: true, preserveWhitespace: (node) => true));
    sink.close();
  }

  void _addNote(XmlBuilder builder, Task note) {
    builder.element("note", nest: () {
      builder.attribute("id", note.id);
      builder.element("title", nest: () {
        builder.text(note.title);
      });
      if (note.details != null) {
        builder.element("details", nest: () {
          builder.text(note.details!);
        });
      }
      _addChildren(builder, note);
    });
  }

  void _addChildren(XmlBuilder builder, Task note) {
    if (note.children.isNotEmpty) {
      builder.element("children", nest: () {
        for (var note in note.children) {
          _addNote(builder, note);
        }
      });
    }
  }

  static Task _deserializeNote(XmlElement noteXml) {
    var title = noteXml.getElement("title")!.text;
    var details;
    var detailsXml = noteXml.getElement("details");
    if (detailsXml != null) {
      details = detailsXml.text;
    }
    return Task(
      id: noteXml.getAttribute("id")!,
      title: title,
      details: details,
      children: _deserializeChildren(noteXml),
    );
  }

  static List<Task> _deserializeChildren(XmlElement noteXml) {
    var result = <Task>[];
    var childrenXml = noteXml.getElement("children");
    if (childrenXml != null) {
      var notesXml = childrenXml.findElements("note");
      for (var noteXml in notesXml) {
        result.add(_deserializeNote(noteXml));
      }
    }
    return result;
  }

  static File _buildFile(String path) {
    var normalizedPath = path
        .replaceAll("~", absolute(Platform.environment["HOME"]!))
        // As workaround for https://github.com/flutter/flutter/issues/68713, "*" is used as synonym for "~".
        .replaceAll("*", absolute(Platform.environment["HOME"]!));
    print("[DEBUG] Build path: $normalizedPath");
    return File(normalizedPath);
  }

  void decrementIndex(Task noteToBeMoved) {
    _changeIndex(noteToBeMoved, -1);
  }

  void incrementIndex(Task noteToBeMoved) {
    _changeIndex(noteToBeMoved, 1);
  }

  void _changeIndex(Task noteToBeMoved, int offset) {
    late List<Task> siblings;
    var rootNotes = tasks.getRootTasks();
    if (rootNotes.contains(noteToBeMoved)) {
      siblings = rootNotes;
    } else {
      var parentNote = tasks.findParentTask(noteToBeMoved)!;
      siblings = parentNote.children;
    }
    final oldIndex = siblings.indexOf(noteToBeMoved);
    if (offset < 0 && oldIndex == 0) return;
    if (offset > 0 && oldIndex == siblings.length - 1) return;
    siblings.removeAt(oldIndex);
    siblings.insert(oldIndex + offset, noteToBeMoved);

    save();
  }
}
