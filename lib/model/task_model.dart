class Task {
  final int? id;
  final String title;
  final String desc;
  final String dateandtime;

  const Task({
    this.id,
    required this.title,
    required this.desc,
    required this.dateandtime,
  });

  // Convert a Task into a Map.
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'desc': desc, 'dateandtime': dateandtime};
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, desc: $desc, dateandtime: $dateandtime}';
  }
}
