import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/utils/util_function.dart';

import '../models/task.dart';
import '../screens/tasks_list.dart';

class TaskItem extends ConsumerWidget {
  final int index;

  final TaskList widget;

  final Task task;
  Map<Category, Color> textColorMap = {
    Category.one: Colors.black,
    Category.two: Colors.black,
    Category.three: Colors.white,
    Category.four: Colors.white,
  };

  final void Function() onRemoveTask;
  final void Function() onEditTask;

  TaskItem({
    super.key,
    required this.index,
    required this.widget,
    required this.task,
    required this.onRemoveTask,
    required this.onEditTask,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PhysicalModel(
      color: Colors.transparent,
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                matchColorWithCategory(widget.category).withOpacity(0.85),
                matchColorWithCategory(widget.category).withOpacity(0.56),
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
                onPressed: onEditTask,
                icon: Icon(
                  Icons.edit,
                  color: textColorMap[widget.category]!.withAlpha(200),
                ),
              ),
              IconButton(
                onPressed: onRemoveTask,
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
