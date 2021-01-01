
import 'dart:io';

import 'package:succedo_desktop/core/note_repository.dart';
import 'package:xml/xml.dart';

import 'note.dart';

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
    var file = File(path);
    var fileContents = file.readAsStringSync();
    var document = XmlDocument.parse(fileContents);
    var element = document.getElement("project");
    title = element!.getAttribute("title")!;

    _current = this;
  }

  static Project get current {
    return _current!;
  }

  void save() {
    var file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('project', nest: () {
      builder.attribute('title', title);

      builder.element('notes', nest: () {
        for(var note in notes.getAllNotes()) {
          _addNote(builder, note);
        }
      });

    });
    final projectXml = builder.buildDocument();

    var sink = file.openWrite();
    sink.write(projectXml.toXmlString(pretty: true));
    sink.close();
  }

  void _addNote(XmlBuilder builder, Note note) {
    builder.element('note', nest: () {
      builder.element('title', nest: () {
        builder.text(note.title);
      });
      if (note.details != null) {
        builder.element('details', nest: () {
          builder.text(note.details!);
        });
      }
      _addChildren(builder, note);
    });
  }

  void _addChildren(XmlBuilder builder, Note note) {
    if (note.children.isNotEmpty) {
      builder.element("children", nest: () {
        for(var note in note.children) {
          _addNote(builder, note);
        }
      });
    }
  }
}
