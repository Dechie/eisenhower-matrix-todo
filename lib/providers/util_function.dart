import 'package:todo/models/task.dart';

Category findCategory(Task inState) {
  return switch ((inState.importance, inState.urgency)) {
    (Importance.high, Urgency.urgent) => Category.one,
    (Importance.high, Urgency.notUrgent) => Category.two,
    (Importance.low, Urgency.urgent) => Category.three,
    (Importance.low, Urgency.notUrgent) => Category.four,
  };
}
