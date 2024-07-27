import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../utils/util_function.dart';

final myTasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) => TasksNotifier(),
);

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super([]) {
    state = refresh();
  }

  bool addItem(Task task) {
    if (!state.contains(task)) {
      addToHive(task);
      state = [task, ...state];
      return true;
    }
    return false;
  }

  bool editItem(Task oldTask, Task newTask) {
    //if (state.contains(oldTask)) return false;
    if (oldTask == newTask) {
      return false;
    }
    print("old task: ${oldTask.id}");
    print("tasks list:");
    var tss =
        getListByCategory(findCategory(oldTask)).map((t) => t.id).toList();

    print(tss);
    Task inState = state.firstWhere((test) => test.id == oldTask.id);

    int index = state.indexOf(inState);
    var stateTemp = state.where((test) => test.id != inState.id).toList();
    // option one: edit in place
    // stateTemp.insert(index, task);
    // state = stateTemp;

    // option two: remove from place and add to front
    state = [newTask, ...stateTemp];
    return true;
  }

  List<Task> getListByCategory(Category category) {
    var (urgency, importance) = findAttribuesFromCategory(category);
    return state
        .where(
            (task) => task.importance == importance && task.urgency == urgency)
        .toList();
  }

  bool insertItem(Task task) {
    state = [task, ...state];
    return true;
  }

  bool removeItem(Task task) {
    if (state.contains(task)) {
      deleteFromHive(task);
      state = state.where((item) => item.id != task.id).toList();
      return true;
    }
    return false;
  }
}
