class Note {
  String id;
  String title;
  String? details;
  String? icon;
  List<Note> children;

  Note({
    required this.id,
    required this.title,
    this.details = """
# Hypothesis

Something will happen.

# Experiment

```
diff --git a/packages/succedo_desktop/lib/core/note_repository.dart b/packages/succedo_desktop/lib/core/note_repository.dart
index 1b5ad87..7ec71cd 100644
--- a/packages/succedo_desktop/lib/core/note_repository.dart
+++ b/packages/succedo_desktop/lib/core/note_repository.dart
@@ -9,11 +9,23 @@ class NoteRepository {
   }
 
   Note? findNote(String id) {
-    var match = _notes.where((note) => note.id == id);
-    if (match.isEmpty) {
-      return null;
+    Map<String, Note> noteIndex = {};
+    _index(noteIndex, _notes);
+
+    if (noteIndex.containsKey(id)) {
+      return noteIndex[id];
     } else {
-      return match.first;
+      return null;
+    }
+  }
+
+  void _index(Map<String, Note> noteIndex, List<Note> notes) {
+    for (var note in _notes) {
+      noteIndex.putIfAbsent(note.id, () => note);
+      if (note.children.isNotEmpty) {
+        _index(noteIndex, note.children);
+      }
+
     }
   }
 }

```

# Observation

Boom.

# Conclusion

Ever tried, even failed, no better. Try again, fail again, fail better.

    """,
    this.icon,
    this.children = const [],
  });
}
