import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task.dart';
import 'package:todo/providers/categ_1.dart';

import 'categ_2.dart';
import 'categ_4.dart';
import 'util_function.dart';

final categThreeProvider =
    StateNotifierProvider<CategoryThreeNotifier, List<Task>>(
  (ref) => CategoryThreeNotifier(),
);

class CategoryThreeNotifier extends StateNotifier<List<Task>> {
  CategoryThreeNotifier() : super([]);

  void addOrRemoveItem(Task task) {
    if (state.contains(task)) {
      state = state.where((item) => item.id != task.id).toList();
    } else {
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
      case Category.one:
        state = state.where((test) => test.id != task.id).toList();
        ref.read(categOneProvider.notifier).addOrRemoveItem(task);
        break;
      case Category.two:
        state = state.where((test) => test.id != task.id).toList();
        ref.read(categTwoProvider.notifier).addOrRemoveItem(task);
      case Category.four:
        state = state.where((test) => test.id != task.id).toList();
        ref.read(categFourProvider.notifier).addOrRemoveItem(task);

      default:
        break;
    }
  }

  
}
