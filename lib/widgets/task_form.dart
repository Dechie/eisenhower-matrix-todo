import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task.dart';
import 'package:todo/providers/riv_provider.dart';

import '../utils/util_function.dart';

enum AddOrEdit { add, edit }

class TaskForm extends ConsumerStatefulWidget {
  Task? task;
  final AddOrEdit addOrEdit;
  final Category category;
  TaskForm({
    super.key,
    this.task,
    required this.category,
    required this.addOrEdit,
  });

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> with RestorationMixin {
  String title = '', description = '';
  late Urgency urgency;
  late Importance importance;

  TextEditingController titleCont = TextEditingController();
  TextEditingController descCont = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final RestorableIntN _urgencyIndex;
  late final RestorableIntN _importanceIndex;

  @override
  String get restorationId => 'new_task_widget';

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: MediaQuery.of(context).size.height * .85,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, keyboardSpace + 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter proper title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value!;
                  },
                  initialValue: widget.task == null ? '' : widget.task!.title,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    label: const Text('Title'),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter proper description';
                    }
                    return null;
                  },
                  initialValue:
                      widget.task == null ? '' : widget.task!.description,
                  onSaved: (value) {
                    description = value!;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    label: const Text('description'),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  children: [
                    ChoiceChip(
                      label: const Text('Urgent'),
                      selected: _urgencyIndex.value == 1,
                      onSelected: (value) {
                        setState(() {
                          _urgencyIndex.value = value ? 1 : -1;
                          urgency = Urgency.urgent;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Not Urgent'),
                      selected: _urgencyIndex.value == 2,
                      onSelected: (value) {
                        setState(() {
                          _urgencyIndex.value = value ? 2 : -1;
                          urgency = Urgency.notUrgent;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  children: [
                    ChoiceChip(
                      label: const Text('Importance'),
                      selected: _importanceIndex.value == 1,
                      onSelected: (value) {
                        setState(() {
                          _importanceIndex.value = value ? 1 : -1;
                          importance = Importance.high;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Not Important'),
                      selected: _importanceIndex.value == 2,
                      onSelected: (value) {
                        setState(() {
                          _importanceIndex.value = value ? 2 : -1;
                          importance = Importance.low;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _submitTask,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urgencyIndex.dispose();
    _importanceIndex.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    var (taskUrgency, taskImportance) =
        findAttribuesFromCategory(widget.category);
    urgency = taskUrgency;
    importance = taskImportance;
    _urgencyIndex =
        urgency == Urgency.urgent ? RestorableIntN(1) : RestorableIntN(2);
    _importanceIndex =
        importance == Importance.high ? RestorableIntN(1) : RestorableIntN(2);
    setState(() {});
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_urgencyIndex, 'choice_chip');
    registerForRestoration(_importanceIndex, 'choice_chip');
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Task newTask = Task(
        title: title,
        description: description,
        completed: false,
        importance: importance,
        urgency: urgency,
      );
      print(newTask.toString());

      // perform edit function or create function
      // based on request
      var notifer = ref.read(myTasksProvider.notifier);
      switch (widget.addOrEdit) {
        case AddOrEdit.add:
          bool wasAdded = notifer.addItem(newTask);
          if (wasAdded) {
            displaySnackbar(context, "Successfully added task");
          } else {
            displaySnackbar(context, "couldn't add task");
          }
          Navigator.pop(context, wasAdded);
          break;
        case AddOrEdit.edit:
          bool wasEdited = notifer.editItem(widget.task!, newTask);
          if (wasEdited) {
            displaySnackbar(context, "successfully edited task");
          } else {
            displaySnackbar(context, "failed to edit task");
          }
          Navigator.pop(context, wasEdited);
          break;
      }
    }
  }
}
