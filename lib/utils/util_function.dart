import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:todo/models/task.dart';
import 'package:todo/providers/riv_provider.dart';

final _tasksBox = Hive.box('tasks_box');
Future<void> addToHive(Task task) async {
  await _tasksBox.add(task.toMap());
  print('new task added, tasks length: ${_tasksBox.length}');
}

Future<void> deleteFromHive(Task task) async {
  await _tasksBox.delete(task.key);
}

bool displayRemoveSnackbar(
  BuildContext context,
  WidgetRef ref,
  Task task,
  String message,
  void Function(bool) callBack,
) {
  bool reInserted = false;
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Text(message),
            const Spacer(),
            TextButton(
              onPressed: () {
                bool wasInserted =
                    ref.read(myTasksProvider.notifier).addItem(task);

                reInserted = wasInserted;
                callBack(wasInserted);
              },
              child: const Text(
                "Undo",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        )),
  );
  return reInserted;
}

void displaySnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

(Urgency, Importance) findAttribuesFromCategory(Category category) {
  Map<Category, (Urgency, Importance)> valuesMatch = {
    Category.one: (Urgency.urgent, Importance.high),
    Category.two: (Urgency.notUrgent, Importance.high),
    Category.three: (Urgency.urgent, Importance.low),
    Category.four: (Urgency.notUrgent, Importance.low),
  };
  return valuesMatch[category]!;
}

Category findCategory(Task inState) {
  return switch ((inState.importance, inState.urgency)) {
    (Importance.high, Urgency.urgent) => Category.one,
    (Importance.high, Urgency.notUrgent) => Category.two,
    (Importance.low, Urgency.urgent) => Category.three,
    (Importance.low, Urgency.notUrgent) => Category.four,
  };
}

Color matchColorWithCategory(Category category) {
  return switch (category) {
    Category.one => Colors.blue,
    Category.two => Colors.amber,
    Category.three => Colors.green,
    Category.four => Colors.purple,
  };
}

List<Task> refresh() {
  final dataList = _tasksBox.keys.map((key) {
    final item = _tasksBox.get(key);
    item["key"] = key;
    print(item);
    return Task.fromHiveMap(item);
  }).toList();
  return dataList;
}

Future<void> updateInHive(Task task) async {
  await _tasksBox.put(task.key, task.toMap());
}
