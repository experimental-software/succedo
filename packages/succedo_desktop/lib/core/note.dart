class Note {
  String? id;
  String title;
  String? description;
  String? icon;
  List<Note> children;

  Note({
    required this.title,
    this.description,
    this.icon,
    this.children = const [],
  });
}
