import 'package:succedo/core/task.dart';
import 'package:uuid/uuid.dart';

class TaskRepository {
  late List<Task> _tasks;
  late Map<String, Task> _taskIndex;

  TaskRepository() {
    _tasks = _dummyTasks();
    _taskIndex = {};
    _index(_taskIndex, _tasks);
  }

  TaskRepository.empty() {
    _tasks = [];
    _taskIndex = {};
  }

  List<Task> getRootTasks() {
    return _tasks;
  }

  Task? findTask(String id) {
    if (_taskIndex.containsKey(id)) {
      return _taskIndex[id];
    } else {
      return null;
    }
  }

  Task? findParentTask(Task task) {
    for (var potentialParent in _taskIndex.values) {
      if (potentialParent.children.contains(task)) return potentialParent;
    }
    return null;
  }

  void append(Task task) {
    _tasks.add(task);
    _index(_taskIndex, [task]);
  }

  void prepend(Task task) {
    _tasks.insert(0, task);
    _index(_taskIndex, [task]);
  }

  void _index(Map<String, Task> taskIndex, List<Task> tasks) {
    for (var task in tasks) {
      taskIndex.putIfAbsent(task.id, () => task);
      if (task.children.isNotEmpty) {
        _index(taskIndex, task.children);
      }
    }
  }
  
  void remove(Task task) {
    for (var i in _taskIndex.keys) {
      var n = _taskIndex[i]!;
      bool hasRemovedChild = n.removeChild(task);
      if (hasRemovedChild) return;
    }
    _tasks.remove(task);
  }

  void registerChild(Task subtask, String? parentId) {
    _taskIndex.putIfAbsent(subtask.id, () => subtask);
    if (parentId == null) {
      _tasks.add(subtask);
    } else {
      var parentTask = _taskIndex[parentId];
      if (parentTask == null) {
        throw "Could not find parent task $parentId";
      }
      parentTask.children.add(subtask);
    }
  }
}

// TODO Remove dummy tasks from production code
List<Task> _dummyTasks() {
  var collapseCss = Task(id: Uuid().v4(), title: "Einklappen von Hauptmenü für nichtselektierte Tutorials");
  var m1 = Task(id: Uuid().v4(), title: "M1", children: [collapseCss]);
  var migrateTutorials = Task(id: Uuid().v4(), title: "Migration von bestehenden Tutorials", children: [
    Task(
      id: Uuid().v4(),
      title: "Migration von Tutorial 1",
    ),
    Task(
      id: Uuid().v4(),
      title: "Migration von Tutorial 2",
    ),
  ]);
  var migratePresentations = Task(id: Uuid().v4(), title: "Migration von Präsentationen", children: [
    Task(
      id: Uuid().v4(),
      title: "Migration von Präsentation 1",
    ),
    Task(
      id: Uuid().v4(),
      title: "Migration von Präsentation 2",
    ),
  ]);
  var mvp = Task(id: Uuid().v4(), title: "MVP", children: [migratePresentations, migrateTutorials]);
  var postMvp = Task(id: Uuid().v4(), title: "Post-MVP");

  return [m1, mvp, postMvp];
}
