import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:todo/widgets/category_item.dart';
import 'package:todo/widgets/task_form.dart';

import 'models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  final _tasksBox = Hive.box('tasks_box');

  List<Task> tasks = [];
  List<Task> firstCat = [], secondCat = [], thirdCat = [], fourthCat = [];

  Future<void> _addToHive(Task task) async {
    await _tasksBox.add(task.toMap());
    print('new task added, tasks length: ${_tasksBox.length}');
  }

  Future<void> _updateInHive(Task task) async {
    await _tasksBox.put(task.key, task);
    _refresh();
  }

  void _refresh() {
    isLoading = true;
    final dataList = _tasksBox.keys.map((key) {
      final item = _tasksBox.get(key);
      item["key"] = key;
      print(item);
      return Task.fromHiveMap(item);
    }).toList();

    tasks = dataList;
    firstCat = tasks
        .where((task) =>
            task.importance == Importance.high &&
            task.urgency == Urgency.urgent)
        .toList();
    secondCat = tasks
        .where((task) =>
            task.importance == Importance.high &&
            task.urgency == Urgency.notUrgent)
        .toList();
    thirdCat = tasks
        .where((task) =>
            task.importance == Importance.low && task.urgency == Urgency.urgent)
        .toList();
    fourthCat = tasks
        .where((task) =>
            task.importance == Importance.low &&
            task.urgency == Urgency.notUrgent)
        .toList();
    // tasks.forEach((task) {
    //   // important
    //   if (task.importance == Importance.high) {
    //     if (task.urgency == Urgency.urgent && !firstCat.contains(task)) {
    //       // imprtant and urgent
    //       firstCat.add(task);
    //     } else if (task.urgency == Urgency.notUrgent &&
    //         !secondCat.contains(task)) {
    //       // important but not urgent
    //       secondCat.add(task);
    //     }
    //   } else if (task.importance == Importance.low) {
    //     // not important
    //     if (task.urgency == Urgency.urgent && !thirdCat.contains(task)) {
    //       // urgent but not important
    //       thirdCat.add(task);
    //     } else if (task.urgency == Urgency.notUrgent &&
    //         !fourthCat.contains(task)) {
    //       // not urgent and not important
    //       fourthCat.add(task);
    //     }
    //   }
    // });
    setState(() {
      isLoading = false;
    });
  }

  void _addTask(Task task) {
    _addToHive(task);
    _refresh();
  }

  void _openAddOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => TaskForm(onAddTask: _addTask),
    );
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
      body: Center(
        child: SizedBox(
          width: size.width * .8,
          height: size.height * .8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Your Quadrants',
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                      //fontSize: 24,
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              SizedBox(
                width: size.width * .8,
                height: size.height * .8 - 50,
                child: GridView(
                  //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  children: [
                    CategoryWidget(
                      color: Colors.blue,
                      title: 'Quadrant One',
                      subtitle: 'Urgent and Important',
                      ctx: context,
                      tasks: firstCat,
                      taskUpdate: _updateInHive,
                      category: Category.one,
                    ),
                    CategoryWidget(
                      color: Colors.amber,
                      title: 'Quadrant two',
                      subtitle: 'Important, but Not Urgent',
                      ctx: context,
                      tasks: secondCat,
                      taskUpdate: _updateInHive,
                      category: Category.two,
                    ),
                    CategoryWidget(
                      color: Colors.green,
                      title: 'Quadrant Three',
                      subtitle: 'Urgent, but Not Important',
                      ctx: context,
                      tasks: thirdCat,
                      taskUpdate: _updateInHive,
                      category: Category.three,
                    ),
                    CategoryWidget(
                      color: Colors.purple,
                      title: 'Quadrant Four',
                      subtitle: 'Not Urgent and Not Important',
                      ctx: context,
                      tasks: fourthCat,
                      taskUpdate: _updateInHive,
                      category: Category.four,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
