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
}
