enum Importance { high, low }

enum Urgency { urgent, notUrgent }

enum Category { one, two, three, four }

class Task {
  const Task({
    required this.title,
    required this.description,
    required this.completed,
    required this.importance,
    required this.urgency,
    this.key = 0,
  });

  final String title, description;
  final int key;
  final bool completed;
  final Importance importance;
  final Urgency urgency;

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      key: map['key'],
      title: map['title'],
      description: map['description'],
      completed: map['completed'],
      importance: map['importance'],
      urgency: map['urgency'],
    );
  }

  factory Task.fromHiveMap(Map<dynamic, dynamic> map) {
    Map<String, Importance> importanceMap = {
      "Importance.high": Importance.high,
      "Importance.low": Importance.low,
    };

    Map<String, Urgency> urgencyMap = {
      "Urgency.urgent": Urgency.urgent,
      "Urgency.notUrgent": Urgency.notUrgent,
    };
    return Task(
      key: map['key'],
      title: map['title'],
      description: map['description'],
      completed: map['completed'],
      importance: importanceMap[map['importance']]!,
      urgency: urgencyMap[map['urgency']]!,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "completed": completed,
      "importance": importance.toString(),
      "urgency": urgency.toString(),
    };
  }

  @override
  String toString() {
    return '{title: "$title", description: "$description", completed: "$completed", urgency: "${urgency.toString()}", importance: "${importance.toString()}",}';
  }
}
