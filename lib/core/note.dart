import 'package:succedo/core/project.dart';

class Note {
  String id;
  String title;
  String? details;
  String? icon;
  List<Note> children;

  Note({
    required this.id,
    required this.title,
    this.details,
    this.icon,
    this.children = const [],
  }) {
    if (children.isEmpty) {
      children = []; // Replaces the default "const" list with a modifiable list.
    }
  }

  bool removeChild(Note note) {
    return children.remove(note);
  }

  Note? get parent {
    return Project.current.notes.findParentNote(this);
  }

  List<Note> get ancestors {
    return _ancestors(this, []);
  }

  static List<Note> _ancestors(Note note, List<Note> ancestors) {
    var parent = note.parent;
    if (parent != null) {
      ancestors.add(parent);
      return _ancestors(parent, ancestors);
    } else {
      return ancestors;
    }
  }
}
