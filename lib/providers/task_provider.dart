import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];
  List<Task> _firstCat = [], _secondCat = [], _thirdCat = [], _fourthCat = [];

  List<Task> get firstCat => _firstCat;
  List<Task> get secondCat => _secondCat;
  List<Task> get thirdCat => _thirdCat;
  List<Task> get fourthCat => _fourthCat;

  final _tasksBox = Hive.box('tasks_box');

  TaskProvider() {
    _refresh();
  }

  Future<void> addToHive(Task task) async {
    await _tasksBox.add(task.toMap());
    _refresh();
    print('new task added, tasks length: ${_tasksBox.length}');
  }

  Future<void> updateInHive(Task task) async {
    await _tasksBox.put(task.key, task.toMap());
    _refresh();
  }

  Future<void> deleteTask(Task task) async {
    await _tasksBox.delete(task.key);
    _refresh();
  }

  List<Task> getList(Category category) {
    switch (category) {
      case Category.one:
        return firstCat;

      case Category.two:
        return secondCat;

      case Category.three:
        return thirdCat;

      case Category.four:
        return fourthCat;
    }
  }

  void _refresh() {
    final dataList = _tasksBox.keys.map((key) {
      final item = _tasksBox.get(key);
      item["key"] = key;
      print(item);
      return Task.fromHiveMap(item);
    }).toList();

    tasks = dataList;
    _firstCat = tasks
        .where((task) =>
            task.importance == Importance.high &&
            task.urgency == Urgency.urgent)
        .toList();
    _secondCat = tasks
        .where((task) =>
            task.importance == Importance.high &&
            task.urgency == Urgency.notUrgent)
        .toList();
    _thirdCat = tasks
        .where((task) =>
            task.importance == Importance.low && task.urgency == Urgency.urgent)
        .toList();
    _fourthCat = tasks
        .where((task) =>
            task.importance == Importance.low &&
            task.urgency == Urgency.notUrgent)
        .toList();
    notifyListeners();
  }

  void addTask(Task task) {
    addToHive(task);
    _refresh();
  }
}
