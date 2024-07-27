import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/providers/riv_provider.dart';
import 'package:todo/utils/util_function.dart';

import '../models/task.dart';
import '../widgets/task_form.dart';
import '../widgets/task_item.dart';

class TaskList extends ConsumerStatefulWidget {
  final Category category;

  const TaskList({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<TaskList> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskList> {
  List<Task> tasks = [];
  @override
  Widget build(BuildContext context) {
    var catName = widget.category.toString().split('.').join(" ");
    print("tasks before build: ${tasks.length}");
    tasks =
        ref.watch(myTasksProvider.notifier).getListByCategory(widget.category);
    print("tasks after build: ${tasks.length}");
    var buttonColor = matchColorWithCategory(widget.category);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        centerTitle: true,
        title: Text(
          catName,
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        elevation: 8,
        onPressed: _openAddOverlay,
        child: PhysicalModel(
          color: Colors.transparent,
          child: SizedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    buttonColor.withOpacity(0.77),
                    buttonColor.withOpacity(0.56),
                  ],
                ),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .8,
                  child: tasks.isEmpty
                      ? const Center(
                          child: Text("No taks for this category"),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListView.separated(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              return TaskItem(
                                  index: index,
                                  widget: widget,
                                  task: tasks[index],
                                  onEditTask: () {
                                    reditTask(tasks[index]);
                                  },
                                  onRemoveTask: () {
                                    bool reInserted = removeTask(tasks[index]);
                                    print(
                                        "tasks after reinserting: ${tasks.length}");
                                    if (reInserted) {
                                      print(
                                          "tasks after reinserting: ${tasks.length}");
                                      tasks = ref
                                          .read(myTasksProvider.notifier)
                                          .getListByCategory(widget.category);
                                      setState(() {});
                                    }
                                  });
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void reditTask(Task task) async {
    bool status = await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => TaskForm(
        addOrEdit: AddOrEdit.edit,
        task: task,
        category: widget.category,
      ),
    );

    if (status) {
      tasks =
          ref.read(myTasksProvider.notifier).getListByCategory(widget.category);
      setState(() {});
    }
  }

  void reInstertCallback(bool reInserted) {
    if (reInserted) {
      
      tasks =
          ref.read(myTasksProvider.notifier).getListByCategory(widget.category);
      setState(() {});
      displaySnackbar(context, "Added item back");
    }
  }

  bool removeTask(Task task) {
    int tasksBefore = tasks.length;
    print("tasks before deleting: $tasksBefore}");
    bool wasRemoved = ref.read(myTasksProvider.notifier).removeItem(task);

    if (wasRemoved) {
      tasks =
          ref.read(myTasksProvider.notifier).getListByCategory(widget.category);
      setState(() {});
    }
    bool reInserted = false;
    print("tasks right after deleting: ${tasks.length}");
    if (wasRemoved) {
      reInserted = displayRemoveSnackbar(
        context,
        ref,
        task,
        "Successfully removed item",
        reInstertCallback,
      );
      if (reInserted) {
        displaySnackbar(context, "Added item back");
      }
    } else {
      displaySnackbar(context, "couldn't remove item");
    }
    int tasksAfter = tasks.length;

    return reInserted;
  }

  void _openAddOverlay() async {
    bool status = await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => TaskForm(
        addOrEdit: AddOrEdit.add,
        category: widget.category,
      ),
    );

    if (status) {
      tasks =
          ref.read(myTasksProvider.notifier).getListByCategory(widget.category);
      setState(() {});
    }
  }
}
