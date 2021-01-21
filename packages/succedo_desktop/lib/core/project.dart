import "dart:io";

import "package:path/path.dart";
import "package:succedo_desktop/core/note_repository.dart";
import "package:xml/xml.dart";

import "note.dart";

class Project {
  static Project? _current;

  late String title;
  late String path;
  late NoteRepository notes;

  Project({required this.title, required this.path});

  Project.create({required this.title, required this.path}) {
    notes = NoteRepository.empty();
    save();

    _current = this;
  }

  Project.load({required this.path}) {
    notes = NoteRepository.empty();
    var file = _buildFile(path);
    if (!file.existsSync()) {
      throw "File with path ${file.absolute.path} does not exist.";
    }
    var fileContents = file.readAsStringSync();
    var document = XmlDocument.parse(fileContents);
    var projectNode = document.getElement("project");
    title = projectNode!.getAttribute("title")!;
    var notesXml = projectNode.getElement("notes");
    if (notesXml != null) {
      for (var noteXml in notesXml.findElements("note")) {
        notes.add(_deserializeNote(noteXml));
      }
    }

    _current = this;
  }

  static Project get current {
    return _current!;
  }

  Future save() async {
    var file = _buildFile(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    final builder = XmlBuilder();
    builder.processing("xml", "version='1.0'");
    builder.element("project", nest: () {
      builder.attribute("title", title);

      builder.element("notes", nest: () {
        for (var note in notes.getRootNotes()) {
          _addNote(builder, note);
        }
      });
    });
    final projectXml = builder.buildDocument();

    var sink = file.openWrite();
    sink.write(projectXml.toXmlString(pretty: true, preserveWhitespace: (node) => true));
    sink.close();
  }

  void _addNote(XmlBuilder builder, Note note) {
    builder.element("note", nest: () {
      builder.attribute("id", note.id);
      builder.element("title", nest: () {
        builder.text(note.title);
      });
      if (note.details != null) {
        builder.element("details", nest: () {
          // TODO Replace all is not needed
          builder.text(note.details!.replaceAll('\\n', '\n'));
        });
      }
      _addChildren(builder, note);
    });
  }

  void _addChildren(XmlBuilder builder, Note note) {
    if (note.children.isNotEmpty) {
      builder.element("children", nest: () {
        for (var note in note.children) {
          _addNote(builder, note);
        }
      });
    }
  }

  static Note _deserializeNote(XmlElement noteXml) {
    var title = noteXml.getElement("title")!.text;
    var details;
    var detailsXml = noteXml.getElement("details");
    if (detailsXml != null) {
      details = detailsXml.text;
    }
    return Note(
      id: noteXml.getAttribute("id")!,
      title: title,
      details: details,
      children: _deserializeChildren(noteXml),
    );
  }

  static List<Note> _deserializeChildren(XmlElement noteXml) {
    var result = <Note>[];
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
    return File(normalizedPath);
  }

  static Future<void> saveLastProject(String lastProjectPath, String configFilePath) async {
    if (await File(configFilePath).exists()) {
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

  void decrementIndex(Note noteToBeMoved) {
    _changeIndex(noteToBeMoved, -1);
  }

  void incrementIndex(Note noteToBeMoved) {
    _changeIndex(noteToBeMoved, 1);
  }

  void _changeIndex(Note noteToBeMoved, int offset) {
    late List<Note> siblings;
    var rootNotes = notes.getRootNotes();
    if (rootNotes.contains(noteToBeMoved)) {
      siblings = rootNotes;
    } else {
      var parentNote = notes.findParentNote(noteToBeMoved)!;
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
