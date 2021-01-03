// @dart=2.9
import 'package:succedo_desktop/core/note_repository.dart';
import 'package:succedo_desktop/core/project.dart';
import "package:test/test.dart";

void main() {
  test("Should find nested note", () {
    var path = "test_resources/test_project_nested.xml";
    var project = Project.load(path: path);
    var nestedNote = project.notes.getRootNotes()[0].children[0].children[0];

    var retrievedNote = project.notes.findNote(nestedNote.id);

    expect(retrievedNote, equals(nestedNote));
  });

  test("Should update parent note", () {
    var noteRepository = NoteRepository();
    var firstNote = noteRepository.getRootNotes()[0];
    expect(firstNote.children.length, equals(1));
    var thirdNote = noteRepository.getRootNotes()[2];
    expect(thirdNote.children.length, equals(0));
    var noteToBeMoved = firstNote.children[0];

    noteRepository.remove(noteToBeMoved);
    noteRepository.registerChild(noteToBeMoved, thirdNote.id);

    expect(thirdNote.children.length, equals(1));
    expect(firstNote.children.length, equals(0));
  });
}
