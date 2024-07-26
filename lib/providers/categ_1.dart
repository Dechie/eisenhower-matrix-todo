import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task.dart';

final categOneProvider = StateNotifierProvider<CategoryOneNotifier, List<Task>>(
  (ref) => CategoryOneNotifier(),
);

final categTwoProvider = StateNotifierProvider<CategoryTwoNotifier, List<Task>>(
  (ref) => CategoryTwoNotifier(),
);

class CategoryOneNotifier extends StateNotifier<List<Task>> {
  CategoryOneNotifier() : super([]);

  void addOrRemoveItem(Task task) {
    if (state.contains(task)) {
      state = state.where((item) => item.id != task.id).toList();
    } else {
      state = [task, ...state];
    }
  }
}

class CategoryTwoNotifier extends StateNotifier<List<Task>> {
  CategoryTwoNotifier() : super([]);
  void addOrRemoveItem(Task task) {
    if (state.contains(task)) {
      state = state.where((item) => item.id != task.id).toList();
    } else {
      state = [task, ...state];
    }
  }
}
