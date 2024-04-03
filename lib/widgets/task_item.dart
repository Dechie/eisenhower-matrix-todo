import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/widgets/task_form.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/tasks_list.dart';

class TaskItem extends StatelessWidget {
  TaskItem({
    super.key,
    required this.index,
    required this.widget,
    required this.task,
  });

  final int index;

  final TaskList widget;
  final Task task;

  Map<Category, Color> colorMap = {
    Category.one: Colors.blue,
    Category.two: Colors.amber,
    Category.three: Colors.green,
    Category.four: Colors.purple,
  };

  Map<Category, Color> textColorMap = {
    Category.one: Colors.black,
    Category.two: Colors.black,
    Category.three: Colors.white,
    Category.four: Colors.white,
  };

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return PhysicalModel(
      color: Colors.transparent,
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                colorMap[widget.category]!.withOpacity(0.85),
                colorMap[widget.category]!.withOpacity(0.56),
              ],
              end: Alignment.centerRight,
              begin: Alignment.centerLeft,
            )),
        child: ListTile(
          isThreeLine: true,
          title: Text(
            task.title,
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: textColorMap[widget.category]!.withAlpha(220),
              ),
            ),
          ),
          subtitle: Text(
            task.description,
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColorMap[widget.category]!.withAlpha(220),
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (ctx) => TaskForm(
                      task: task,
                      onEditTask: (updatedTask) {
                        final index = taskProvider.tasks
                            .indexWhere((task) => task.key == updatedTask.key);
                        if (index != -1) {
                          // Update the task at the found index
                          taskProvider.tasks[index] = updatedTask;
                          // Update the task in Hive
                          taskProvider.updateInHive(updatedTask);
                        }
                      },
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: textColorMap[widget.category]!.withAlpha(200),
                ),
              ),
              IconButton(
                onPressed: () {
                  taskProvider.deleteTask(task);
                },
                icon: Icon(
                  Icons.delete,
                  color: textColorMap[widget.category]!.withAlpha(200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
