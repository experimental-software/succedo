
import 'package:succedo_desktop/core/note_repository.dart';

class Project {
  static Project? _current;

  late String name;
  late String path;
  late NoteRepository notes;

  Project({required this.name, required this.path});

  static void create({required name, required path}) {
    _current = Project(name: name, path: path);
  }

  static Project get current {
    return _current!;
  }
}
