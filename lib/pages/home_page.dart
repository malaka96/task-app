import 'package:flutter/material.dart';
import 'package:test_firebase_project/services/task_service.dart';
import 'package:test_firebase_project/Models/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _taskController.dispose();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(
              hintText: 'Enter task name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await TaskService().addTask(_taskController.text);
                _taskController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskBottomSheet(Task task) {
    _taskController.text = task.name;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    hintText: 'Enter task name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    task.name = _taskController.text;
                    task.updatedAt = DateTime.now();
                    task.isUpdated = true;
                    await TaskService().updateTask(task);
                    _taskController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text('Update Task'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task App')),
      body: StreamBuilder(
        stream: TaskService().getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('error loading taks ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks available'));
          } else {
            final List<Task> tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final Task task = tasks[index];
                return Card(
                  child: ListTile(
                    title: Text(task.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Created At: ${task.createdAt}'),
                        Text('Updated At: ${task.updatedAt}'),
                        Text('Is Updated: ${task.isUpdated}'),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await TaskService().deleteTask(task.id);
                      },
                      icon: Icon(Icons.delete),
                    ),
                    onTap: () => _showEditTaskBottomSheet(task),
                    // onTap: () {
                    //   _showEditTaskBottomSheet(task);
                    // },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
