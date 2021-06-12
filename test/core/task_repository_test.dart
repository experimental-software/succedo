// @dart=2.9
import 'package:succedo/core/task_repository.dart';
import 'package:succedo/core/project.dart';
import "package:test/test.dart";

void main() {
  test("Should find nested task", () {
    var path = "test_resources/test_project_nested.xml";
    var project = Project.load(path: path);
    var nestedTask = project.tasks.getRootTasks()[0].children[0].children[0];

    var retrievedTasks = project.tasks.findTask(nestedTask.id);

    expect(retrievedTasks, equals(nestedTask));
  });

  test("Should update parent task", () {
    var taskRepository = TaskRepository();
    var firstTask = taskRepository.getRootTasks()[0];
    expect(firstTask.children.length, equals(1));
    var thirdTask = taskRepository.getRootTasks()[2];
    expect(thirdTask.children.length, equals(0));
    var taskToBeMoved = firstTask.children[0];

    taskRepository.remove(taskToBeMoved);
    taskRepository.registerChild(taskToBeMoved, thirdTask.id);

    expect(thirdTask.children.length, equals(1));
    expect(firstTask.children.length, equals(0));
  });
}
