import "package:flutter/material.dart";
import 'package:open_url/open_url.dart';
import "package:succedo/core/task.dart";
import "package:succedo/core/task_repository.dart";

import "../core/project.dart";
import "../widgets/editable_task_title.dart";
import "create_task_dialog.dart";

class TaskDetails extends StatefulWidget {
  final Task task;

  TaskDetails(this.task);

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final TaskRepository taskRepository = Project.current.tasks;
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var taskDetails = widget.task.details;
    if (taskDetails != null) {
      descriptionController.text = taskDetails;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      endDrawer: _buildDrawer(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Align _buildBody() {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: TextField(
                controller: descriptionController,
                maxLines: 100,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 20),
                onChanged: (value) {
                  widget.task.details = value;
                  Project.current.save();
                  setState(() {});
                },
              ),
            ),
          ),
          SizedBox(height: 75)
        ],
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        taskRepository.remove(widget.task);
        Project.current.save();
        Navigator.of(context).pop();
      },
      tooltip: "Delete task",
      child: Icon(Icons.done),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: EditableTitle(
        task: widget.task,
        onTitleChanged: (newTitle) {
          widget.task.title = newTitle;
          Project.current.save();
        },
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Add task"),
            onTap: () {
              Navigator.of(context).pop();
              _addTask();
            },
          ),
          ListTile(
            title: Text("Add subtask"),
            onTap: () {
              Navigator.of(context).pop();
              _addSubtask();
            },
          ),
          ListTile(
            title: Text("Feedback"),
            onTap: () {
              Navigator.of(context).pop();
              openUrl("https://github.com/experimental-software/succedo/issues/new");
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addTask() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateTaskDialog(
          onDialogClose: () {
            Project.current.save();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _addSubtask() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateTaskDialog(
          parent: widget.task,
          onDialogClose: () {
            Project.current.save();
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
