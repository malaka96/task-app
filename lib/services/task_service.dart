import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_firebase_project/Models/task_model.dart';

class TaskService {
  final CollectionReference _taskCollection = FirebaseFirestore.instance
      .collection("tasks");

  Future<void> addTask(String name) async {
    try {
      final task = Task(
        id: "",
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUpdated: false,
      );

      final Map<String, dynamic> taskData = task.toJson();

      await _taskCollection.add(taskData);

      print("task successfully added");
    } catch (error) {
      print("Error adding task $error");
    }
  }
}
