import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo/widgets/category_item.dart';
import 'package:todo/widgets/task_form.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  void initState() {
    super.initState();
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
                      category: Category.one,
                    ),
                    CategoryWidget(
                      color: Colors.amber,
                      title: 'Quadrant two',
                      subtitle: 'Important, but Not Urgent',
                      ctx: context,
                      category: Category.two,
                    ),
                    CategoryWidget(
                      color: Colors.green,
                      title: 'Quadrant Three',
                      subtitle: 'Urgent, but Not Important',
                      ctx: context,
                      category: Category.three,
                    ),
                    CategoryWidget(
                      color: Colors.purple,
                      title: 'Quadrant Four',
                      subtitle: 'Not Urgent and Not Important',
                      ctx: context,
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
