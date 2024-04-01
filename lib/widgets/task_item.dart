import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/widgets/task_form.dart';

import '../models/task.dart';
import '../screens/tasks_list.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.index,
    required this.colorMap,
    required this.widget,
    required this.tasks,
    required this.textColorMap,
  });

  final int index;
  final Map<Category, Color> colorMap;
  final TaskList widget;
  final List tasks;
  final Map<Category, Color> textColorMap;

  @override
  Widget build(BuildContext context) {
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
            tasks[index].title,
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: textColorMap[widget.category]!.withAlpha(220),
              ),
            ),
          ),
          subtitle: Text(
            tasks[index].description,
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
                      task: tasks[index],
                      onEditTask: widget.taskUpdate,
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: textColorMap[widget.category]!.withAlpha(200),
                ),
              ),
              IconButton(
                onPressed: () {},
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
