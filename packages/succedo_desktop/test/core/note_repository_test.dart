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

  test("Should update parent note", () {
    var noteRepository = NoteRepository();
    var firstNote = noteRepository.getAllNotes()[0];
    expect(firstNote.children.length, equals(1));
    var thirdNote = noteRepository.getAllNotes()[2];
    expect(thirdNote.children.length, equals(0));

    noteRepository.setParent(firstNote.children[0], thirdNote.id);

    expect(thirdNote.children.length, equals(1));
    expect(firstNote.children.length, equals(0));
  });
}