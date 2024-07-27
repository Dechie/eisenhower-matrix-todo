import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/providers/riv_provider.dart';
import 'package:todo/widgets/category_item.dart';

import '../models/task.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/exports.json");
  }

  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        centerTitle: true,
        title: Text(
          'Eisenhower Matrix',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              //fontSize: 24,
              fontSize: MediaQuery.of(context).size.width * 0.07,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              export();
            },
            icon: Icon(
              Icons.upload,
              color: Colors.grey.shade600,
            ),
          ),
          IconButton(
            onPressed: () {
              import();
            },
            icon: Icon(
              Icons.download,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: size.width * .85,
          height: size.height * .8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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

  Future<File> export() async {
    final tasks = ref
        .read(myTasksProvider)
        .map(
          (task) => json.encode(
            task.toMap(),
          ),
        )
        .toList()
        .join('/n');
    final file = await _localFile;
    return file.writeAsString(tasks);
  }

  Future<dynamic> import() async {
    List<String> values = [];
    try {
      final file = await _localFile;
      final contents = await file.readAsString();

      values = contents.split("/n");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Backup Data", style: GoogleFonts.ubuntu(),),
          content: SizedBox(
            width: 400,
            height: 400,
            child: values.isEmpty ? Center(child: Text("No backup data")) : ListView.separated(
              itemCount: values.length,
              itemBuilder: (context, index) {
                print(values[index]);
                return Text(values[index]);
                },
                separatorBuilder: (context, index) => SizedBox(height:10),
            ),
          ),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            width: 400,
            height: 400,
            child: ListView.builder(
              itemCount: values.length,
              itemBuilder: (context, index) => Text(values[index]),
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
