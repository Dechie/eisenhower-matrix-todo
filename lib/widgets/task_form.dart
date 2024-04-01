import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';

class TaskForm extends StatefulWidget {
  TaskForm({
    super.key,
    this.onAddTask,
    this.onEditTask,
    this.task,
  });

  void Function(Task task)? onAddTask;
  void Function(Task task)? onEditTask;
  Task? task;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> with RestorationMixin {
  String title = '', description = '';
  Urgency urgency = Urgency.urgent;
  Importance importance = Importance.high;

  TextEditingController titleCont = TextEditingController();
  TextEditingController descCont = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final RestorableIntN _urgencyIndex = RestorableIntN(1);
  final RestorableIntN _importanceIndex = RestorableIntN(1);

  @override
  void dispose() {
    _urgencyIndex.dispose();
    _importanceIndex.dispose();
    super.dispose();
  }

  @override
  String get restorationId => 'new_task_widget';

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
      widget.task == null
          ? widget.onAddTask!(newTask)
          : widget.onEditTask!(newTask);

      Navigator.pop(context);
    }
  }

  void _editTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

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
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
