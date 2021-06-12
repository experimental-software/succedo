import 'package:succedo/core/project.dart';

class Task {
  String id;
  String title;
  String? details;
  String? icon;
  List<Task> children;

  Task({
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

  bool removeChild(Task task) {
    return children.remove(task);
  }

  Task? get parent {
    return Project.current.tasks.findParentTask(this);
  }

  List<Task> get ancestors {
    return _ancestors(this, []);
  }

  static List<Task> _ancestors(Task task, List<Task> ancestors) {
    var parent = task.parent;
    if (parent != null) {
      ancestors.add(parent);
      return _ancestors(parent, ancestors);
    } else {
      return ancestors;
    }
  }
}
