// import 'package:flutter_test/flutter_test.dart';
// import 'package:todo/models/task.dart';
// import 'package:todo/providers/task_provider.dart';
// import 'package:your_app/task_provider.dart'; // Import your TaskProvider class

// void main() {
//   group('TaskProvider', () {
//     late TaskProvider taskProvider;

//     setUp(() {
//       taskProvider = TaskProvider();
//     });

//     test('Adding a task adds it to the tasks list', () async {
//       final initialLength = taskProvider.tasks.length;
//       await taskProvider.addTask(Task(
//         completed: false,
//         title: 'Test Task',
//         description: 'Test Description',
//         importance: Importance.high,
//         urgency: Urgency.urgent,
//       ));
//       expect(taskProvider.tasks.length, initialLength + 1);
//     });

//     test('Updating a task updates it in the tasks list', () async {
//       final task = Task(
//         completed: false,
//         title: 'Test Task',
//         description: 'Test Description',
//         importance: Importance.high,
//         urgency: Urgency.urgent,
//       );
//       await taskProvider.addTask(task);
//       final updatedTask = task.copyWith(description: 'Updated Description');
//       await taskProvider.updateInHive(updatedTask);
//       expect(taskProvider.tasks.contains(updatedTask), true);
//     });

//     test('Deleting a task removes it from the tasks list', () async {
//       final task = Task(
//         completed: false,
//         title: 'Test Task',
//         description: 'Test Description',
//         importance: Importance.high,
//         urgency: Urgency.urgent,
//       );
//       await taskProvider.addTask(task);
//       final initialLength = taskProvider.tasks.length;
//       await taskProvider.deleteTask(task);
//       expect(taskProvider.tasks.length, initialLength - 1);
//       expect(taskProvider.tasks.contains(task), false);
//     });
//   });
// }
