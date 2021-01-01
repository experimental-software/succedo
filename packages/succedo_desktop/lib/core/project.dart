
import 'dart:io';

import 'package:succedo_desktop/core/note_repository.dart';

class Project {
  static Project? _current;

  late String name;
  late String path;
  late NoteRepository notes;

  Project({required this.name, required this.path});

  Project.create({required this.name, required this.path}) {
    _current = this;
    notes = NoteRepository();
    save();
  }

  static Project get current {
    return _current!;
  }

  void save() {
    var file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
  }
}
