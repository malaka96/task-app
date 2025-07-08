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

      final DocumentReference docRef = await _taskCollection.add(taskData);

      await docRef.update({"id": docRef.id});
      print("task successfully added with id: ${docRef.id}");
    } catch (error) {
      print("Error adding task $error");
    }
  }

  Stream<List<Task>> getTasks() {
    return _taskCollection.snapshots().map(
      (snapShot) => snapShot.docs
          .map(
            (doc) => Task.fromJson(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList(),
    );
  }

  Future<void> deleteTask(String id) async {
    try {
      await _taskCollection.doc(id).delete();
      print("task successfully deleted");
    } catch (error) {
      print("Error deleting task $error");
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final Map<String, dynamic> taskData = task.toJson();
      await _taskCollection.doc(task.id).update(taskData);
    } catch (error) {
      print('Error updating task $error');
    }
  }
}
