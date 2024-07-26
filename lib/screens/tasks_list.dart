import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_form.dart';
import '../widgets/task_item.dart';

class TaskList extends StatefulWidget {
  final Category category;

  const TaskList({
    super.key,
    required this.category,
  });

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late List<Task> tasks;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        elevation: 8,
        onPressed: _openAddOverlay,
        child: PhysicalModel(
          color: Colors.transparent,
          child: SizedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.purple.withOpacity(0.77),
                    Colors.purple.withOpacity(0.56),
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
                  height: 30,
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
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return TaskItem(
                          index: index,
                          widget: widget,
                          task: tasks[index],
                        );
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
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    tasks = taskProvider.getList(widget.category);
    taskProvider.addListener(() {
      tasks = taskProvider.getList(widget.category);
      setState(() {});
    });
  }

  void _openAddOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => TaskForm(
        onAddTask: Provider.of<TaskProvider>(ctx, listen: false).addToHive,
      ),
    );
  }
}
