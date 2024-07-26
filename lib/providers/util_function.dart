import 'package:hive/hive.dart';
import 'package:todo/models/task.dart';

final _tasksBox = Hive.box('tasks_box');
Future<void> addToHive(Task task) async {
  await _tasksBox.add(task.toMap());
  print('new task added, tasks length: ${_tasksBox.length}');
}

Future<void> deleteTask(Task task) async {
  await _tasksBox.delete(task.key);
}

Category findCategory(Task inState) {
  return switch ((inState.importance, inState.urgency)) {
    (Importance.high, Urgency.urgent) => Category.one,
    (Importance.high, Urgency.notUrgent) => Category.two,
    (Importance.low, Urgency.urgent) => Category.three,
    (Importance.low, Urgency.notUrgent) => Category.four,
  };
}

Future<void> updateInHive(Task task) async {
  await _tasksBox.put(task.key, task.toMap());
}
