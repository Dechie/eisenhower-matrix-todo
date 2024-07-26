import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task.dart';

import 'categ_2.dart';
import 'categ_3.dart';
import 'categ_4.dart';
import 'util_function.dart';

final categOneProvider = StateNotifierProvider<CategoryOneNotifier, List<Task>>(
  (ref) => CategoryOneNotifier(),
);

class CategoryOneNotifier extends StateNotifier<List<Task>> {
  CategoryOneNotifier() : super([]);

  void addOrRemoveItem(Task task) {
    if (state.contains(task)) {
      state = state.where((item) => item.id != task.id).toList();
    } else {
      addToHive(task);
      state = [task, ...state];
    }
  }

  void changeItemCategory(Task task, WidgetRef ref) {
    if (!state.contains(task)) return;

    Task inState = state.firstWhere((test) => test.id == task.id);

    Category inStateCategory = findCategory(inState);
    Category taskCategory = findCategory(task);

    if (inStateCategory == taskCategory) return;
    switch (inStateCategory) {
      case Category.two:
        //updateInHive(task);
        state = state.where((test) => test.id != inState.id).toList();
        ref.read(categTwoProvider.notifier).addOrRemoveItem(task);
        break;
      case Category.three:
        state = state.where((test) => test.id != inState.id).toList();
        ref.read(categThreeProvider.notifier).addOrRemoveItem(task);

      case Category.four:
        state = state.where((test) => test.id != inState.id).toList();
        ref.read(categFourProvider.notifier).addOrRemoveItem(task);

      default:
        break;
    }
  }

  void editItem(Task task) {
    if (!state.contains(task)) return;

    Task inState = state.firstWhere((test) => test.id == task.id);

    int index = state.indexOf(inState);
    var stateTemp = state.where((test) => test.id != inState.id).toList();
    // option one: edit in place
    stateTemp.insert(index, task);
    state = stateTemp;

    // option two: remove from place and add to front
    // state = [task, ...state];
  }
}
