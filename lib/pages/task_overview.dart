import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:open_url/open_url.dart';
import 'package:succedo/core/task.dart';
import 'package:succedo/core/task_repository.dart';
import 'package:succedo/routing.dart';

import '../widgets/editable_title.dart';
import 'create_task_dialog.dart';
import 'task_details.dart';
import '../core/project.dart';
import 'project_management.dart';

class TaskOverview extends StatefulWidget {
  TaskOverview({required this.initialTitle});

  final String initialTitle;

  @override
  _TaskOverviewState createState() => _TaskOverviewState();
}

class _TaskOverviewState extends State<TaskOverview> {
  TaskRepository taskRepository = Project.current.tasks;
  FocusNode keyboardFocus = FocusNode();
  Task? taskInTray;

  late TreeViewController treeViewController;

  @override
  void initState() {
    super.initState();
    treeViewController = TreeViewController(children: _toTaskNodes(taskRepository.getRootTasks()));
  }

  @override
  void dispose() {
    keyboardFocus.dispose();
    super.dispose();
  }

  void _addTask() async {
    Task? parent;
    var selectedKey = treeViewController.selectedKey;
    // ignore: unnecessary_null_comparison
    if (selectedKey != null) {
      parent = taskRepository.findTask(selectedKey)!;
    }

    keyboardFocus.unfocus();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateTaskDialog(
          parent: parent,
          onDialogClose: () => Navigator.pop(context),
        );
      },
    );
    keyboardFocus.requestFocus();

    updateTreeView();
  }

  @override
  Widget build(BuildContext context) {
    keyboardFocus.requestFocus();
    return RawKeyboardListener(
      focusNode: keyboardFocus,
      autofocus: true,
      onKey: handleKeyPressed,
      child: Scaffold(
        appBar: AppBar(
          title: EditableTitle(
            initialTitle: widget.initialTitle,
            onTitleChanged: (newTitle) {
              var project = Project.current;
              project.title = newTitle;
              project.save();
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TreeView(
                  controller: treeViewController,
                  allowParentSelect: true,
                  supportParentDoubleTap: false,
                  onNodeTap: (key) {
                    if (key == treeViewController.selectedKey) {
                      var task = taskRepository.findTask(key);
                      if (task == null) {
                        print("[WARNING] Task '$key' not found.");
                        return;
                      }
                      keyboardFocus.unfocus();
                      Navigator.push(
                        context,
                        DesktopPageRoute(builder: (context) {
                          return TaskDetails(task);
                        }),
                      ).then((_) {
                        keyboardFocus.requestFocus();
                        updateTreeView();
                      });
                    } else {
                      setState(() {
                        treeViewController = treeViewController.copyWith(selectedKey: key);
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Text("Feedback"),
                  onTap: () => openUrl("https://github.com/experimental-software/succedo/issues/new"),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addTask,
          tooltip: 'Add task',
          child: Icon(Icons.add),
        ),
        endDrawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text("Create new project"),
                onTap: () => showCreateProjectDialog(context),
              ),
              ListTile(
                title: Text("Open existing project"),
                onTap: () => showOpenExistingProjectDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateTreeView() {
    setState(() {
      treeViewController = TreeViewController(children: _toTaskNodes(taskRepository.getRootTasks()));
    });
  }

  void handleKeyPressed(RawKeyEvent event) {
    var selectedKey = treeViewController.selectedKey;
    // ignore: unnecessary_null_comparison
    if (selectedKey != null) {
      var selectedTask = taskRepository.findTask(selectedKey)!;

      if (event.data.physicalKey == PhysicalKeyboardKey.escape) {
        treeViewController = treeViewController.copyWith(selectedKey: null);
        updateTreeView();
        return;
      }

      if (event.isControlOrCommandPressed && event.data.keyLabel == "x") {
        taskInTray = selectedTask;
        taskRepository.remove(selectedTask);
        treeViewController = treeViewController.copyWith(selectedKey: null);
        updateTreeView();
        return;
      }
      if (event.isControlOrCommandPressed && event.data.keyLabel == "v" && taskInTray != null) {
        taskRepository.registerChild(taskInTray!, selectedTask.id);
        taskInTray = null;
        updateTreeView();
        return;
      }
      if (event.isControlOrCommandPressed && event.isShiftPressed && event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
        Project.current.decrementIndex(selectedTask);
        setState(() {
          treeViewController = TreeViewController(
            children: _toTaskNodes(taskRepository.getRootTasks()),
            selectedKey: selectedTask.id,
          );
        });
        return;
      }
      if (event.isControlOrCommandPressed && event.isShiftPressed && event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
        Project.current.incrementIndex(selectedTask);
        setState(() {
          treeViewController = TreeViewController(
            children: _toTaskNodes(taskRepository.getRootTasks()),
            selectedKey: selectedTask.id,
          );
        });
        return;
      }
    } else {
      if (event.isControlOrCommandPressed && event.character == "v" && taskInTray != null) {
        taskRepository.registerChild(taskInTray!, null);
        taskInTray = null;
        updateTreeView();
        return;
      }
    }
  }
}

extension _CustomEventQueries on RawKeyEvent {
  bool get isControlOrCommandPressed {
    if (Platform.isMacOS) {
      return isMetaPressed;
    } else {
      return isControlPressed;
    }
  }
}

List<Node> _toTaskNodes(List<Task> tasks) {
  List<Node> result = [];
  for (Task task in tasks) {
    Node node = Node(
      label: task.title,
      key: task.id,
      children: _toTaskNodes(task.children),
    );
    result.add(node);
  }
  return result;
}
