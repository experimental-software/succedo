import 'package:succedo_desktop/core/note.dart';
import 'package:uuid/uuid.dart';

class NoteRepository {
  late List<Note> _notes;
  late Map<String, Note> _noteIndex;

  NoteRepository() {
    _notes = _dummyNotes();
    _noteIndex = {};
    _index(_noteIndex, _notes);
  }

  List<Note> getAllNotes() {
    return List.unmodifiable(_notes);
  }

  Note? findNote(String id) {
    if (_noteIndex.containsKey(id)) {
      return _noteIndex[id];
    } else {
      return null;
    }
  }

  void add(Note note) {
    _notes.add(note);
    if (_noteIndex.containsKey(note.id)) {
      _noteIndex.remove(note.id);
    }
    _noteIndex.putIfAbsent(note.id, () => note);
  }

  void _index(Map<String, Note> noteIndex, List<Note> notes) {
    for (var note in notes) {
      noteIndex.putIfAbsent(note.id, () => note);
      if (note.children.isNotEmpty) {
        _index(noteIndex, note.children);
      }
    }
  }
  
  void removeFromParent(Note note) {
    for (var i in _noteIndex.keys) {
      var n = _noteIndex[i]!;
      bool hasRemovedChild = n.removeChild(note);
      if (hasRemovedChild) break;
    }
  }

  void setParent(Note noteToBeMoved, String parentId) {
    var parentNote = _noteIndex[parentId];
    if (parentNote == null) {
      throw "Could not find parent task $parentId";
    }
    parentNote.children.add(noteToBeMoved);
  }
}

List<Note> _dummyNotes() {
  var collapseCss = Note(id: Uuid().v4(), title: "Einklappen von Hauptmenü für nichtselektierte Tutorials");
  var m1 = Note(id: Uuid().v4(), title: "M1", children: [collapseCss]);
  var migrateTutorials = Note(id: Uuid().v4(), title: "Migration von bestehenden Tutorials", children: [
    Note(
      id: Uuid().v4(),
      title: "Migration von Tutorial 1",
    ),
    Note(
      id: Uuid().v4(),
      title: "Migration von Tutorial 2",
    ),
  ]);
  var migratePresentations = Note(id: Uuid().v4(), title: "Migration von Präsentationen", children: [
    Note(
      id: Uuid().v4(),
      title: "Migration von Präsentation 1",
    ),
    Note(
      id: Uuid().v4(),
      title: "Migration von Präsentation 2",
    ),
  ]);
  var mvp = Note(id: Uuid().v4(), title: "MVP", children: [migratePresentations, migrateTutorials]);
  var postMvp = Note(id: Uuid().v4(), title: "Post-MVP");

  return [m1, mvp, postMvp];
}
