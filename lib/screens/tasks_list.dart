import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/task.dart';
import '../widgets/task_item.dart';

class TaskList extends StatefulWidget {
  const TaskList({
    super.key,
    required this.tasks,
    required this.category,
    required this.taskUpdate,
  });

  final List<Task> tasks;
  final Category category;
  final void Function(Task task) taskUpdate;

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late final List tasks;
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
  void initState() {
    super.initState();
    tasks = widget.tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Tasks',
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .8,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ListView.separated(
                      itemCount: widget.tasks.length,
                      itemBuilder: (context, index) => TaskItem(
                        index: index,
                        colorMap: colorMap,
                        widget: widget,
                        tasks: tasks,
                        textColorMap: textColorMap,
                      ),
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
}
