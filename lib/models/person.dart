class Person {
  Person({
    required this.name,
    required this.reliable,
    this.phone,
    this.telegram,
    this.email,
  });

  final String name;
  final bool reliable;
  String? phone, email, telegram;
}
