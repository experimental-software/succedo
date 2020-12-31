// @dart=2.9
import 'package:succedo_desktop/core/note_repository.dart';
import "package:test/test.dart";

void main() {
  test("Should find nested note", () {
    var noteRepository = NoteRepository();
    var nestedNote = noteRepository.getAllNotes()[0].children[0];

    var retrievedNote = noteRepository.findNote(nestedNote.id);

    expect(retrievedNote.id, equals(nestedNote.id));
  });

  
}