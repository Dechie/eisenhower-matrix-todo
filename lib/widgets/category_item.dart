import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/screens/tasks_list.dart';

import '../models/task.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.ctx,
    required this.tasks,
    required this.category,
    required this.taskUpdate,
  });

  final Color color;
  final String title, subtitle;
  final BuildContext ctx;
  final List<Task> tasks;
  final void Function(Task task) taskUpdate;
  final Category category;

  @override
  Widget build(BuildContext context) {
    Map<Category, Color> textColorMap = {
      Category.one: Colors.black,
      Category.two: Colors.black,
      Category.three: Colors.white,
      Category.four: Colors.white,
    };
    final size = MediaQuery.of(ctx).size;
    print("width : ${(size.width * .4 - 20) * 2} and ${size.width}");
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskList(
              tasks: tasks,
              category: category,
              taskUpdate: taskUpdate,
            ),
          ),
        );
      },
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: 8,
        child: GridTile(
          child: SizedBox(
            width: size.width * .4 - 40,
            height: size.height * .4 - 40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(.55),
                    color.withOpacity(.9),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: textColorMap[category],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      children: [
                        Text(
                          subtitle,
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: textColorMap[category],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
