import 'package:succedo_desktop/core/note.dart';
import 'package:uuid/uuid.dart';

class NoteRepository {
  List<Note> _notes = _dummyNotes();

  List<Note> getAllNotes() {
    return _notes;
  }

  Note? findNote(String id) {
    var match = _notes.where((note) => note.id == id);
    if (match.isEmpty) {
      return null;
    } else {
      return match.first;
    }
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
