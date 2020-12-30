import 'package:succedo_desktop/core/note.dart';

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
  var collapseCss = Note(title: "Einklappen von Hauptmenü für nichtselektierte Tutorials");
  var m1 = Note(title: "M1", children: [collapseCss]);
  var migrateTutorials = Note(title: "Migration von bestehenden Tutorials", children: [
    Note(
      title: "Migration von Tutorial 1",
    ),
    Note(
      title: "Migration von Tutorial 2",
    ),
  ]);
  var migratePresentations = Note(title: "Migration von Präsentationen", children: [
    Note(
      title: "Migration von Präsentation 1",
    ),
    Note(
      title: "Migration von Präsentation 2",
    ),
  ]);
  var mvp = Note(title: "MVP", children: [migratePresentations, migrateTutorials]);
  var postMvp = Note(title: "Post-MVP");

  return [m1, mvp, postMvp];
}
