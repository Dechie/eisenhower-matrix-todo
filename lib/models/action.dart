import 'package:todo/models/time_allocated.dart';

import 'person.dart';

enum ActionTaken { dealWith, allocateTime, delegate, eliminate }

class Action {
  Action({
    required this.type,
    this.timeAllocated,
    this.delegatedPerson,
    this.isEliminated = false,
  });

  final ActionTaken type;
  TimeAllocated? timeAllocated;
  Person? delegatedPerson;
  bool isEliminated;
}
