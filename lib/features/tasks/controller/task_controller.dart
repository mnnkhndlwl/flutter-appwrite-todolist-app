import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/api/task_api.dart';
import 'package:todo/core/utils.dart';
import 'package:todo/features/auth/controllers/auth_controller.dart';
import 'package:todo/features/home/view/home_view.dart';
import 'package:todo/models/task_model.dart';

final taskControllerProvider =
    StateNotifierProvider<TaskController, bool>((ref) {
  return TaskController(
    ref: ref,
    taskAPI: ref.watch(taskAPIProvider),
  );
});

final getTaskByUserIdProvider = FutureProvider.family((ref, String id) async {
  final taskController = ref.watch(taskControllerProvider.notifier);
  return taskController.getTasks(id);
});

final getLatestTasksProvider = StreamProvider((ref) {
  final taskAPI = ref.watch(taskAPIProvider);
  return taskAPI.getLatestTasks();
});


class TaskController extends StateNotifier<bool> {
  final TaskAPI _taskAPI;
  final Ref _ref;
  TaskController({
    required Ref ref,
    required TaskAPI taskAPI,
  })  : _ref = ref,
        _taskAPI = taskAPI,
        super(false);

   Future<List<TaskModel>> getTasks(String uid) async {
    final taskList = await _taskAPI.getUserTasks(uid);
    return taskList.map((task) => TaskModel.fromMap(task.data)).toList();
  }

  Future<List<TaskModel>> getCompleted(String uid,bool isCompleted) async {
    final taskList = await _taskAPI.getUsersCompleted(uid,isCompleted);
    return taskList.map((task) => TaskModel.fromMap(task.data)).toList();
  }


  void addTask({
    required String title,
    required String description,
    required String priority,
    required BuildContext context,
  }) async {
    state = true;
    final user = _ref.read(currentUserDetailsProvider).value!;
    TaskModel task = TaskModel(
      title: title,
      description: description,
      priority: priority,
      isCompleted: false,
      uid: user.uid,
      createdAt: DateTime.now(),
      id: '',
    );
    final res = await _taskAPI.addTask(task);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
          showSnackBar(context, 'Task Added');
          Navigator.push(
          context,
          HomeView.route(),
        );
        }
    );
  }      

  void updateTask(
    TaskModel task,
    BuildContext context,
  ) async {
    task = task.copyWith(
      isCompleted: !task.isCompleted,
    );
    final res = await _taskAPI.updateCompleted(task);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        showSnackBar(context, 'marked as completed');
      },
    );
  }

  void deleteTask(
    TaskModel task,
    BuildContext context,
  ) async {
    try {
    final res = await _taskAPI.deleteTask(task);
    } catch (e) {
      print(e.toString()); 
    } 
  }

  void deleteAll(
    String uid,
    BuildContext context,
  ) async {
    try {
    final res = await _taskAPI.deleteAll(uid);
    } catch (e) {
      print(e.toString()); 
    } 
  }

 
}
