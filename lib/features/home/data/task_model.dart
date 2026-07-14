class TaskModel {
  final int sno;
  final String title;
  final String? desc;
  final String priority;
  final String category;
  final String? notes;
  final int status;
  final int pin;
  final String startTime;
  final String endTime;
  final String date;

  TaskModel({
    required this.sno,
    required this.title,
    required this.priority,
    required this.category,
    this.desc,
    this.notes,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.pin,
    required this.date,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
    sno: map["s_no"],
    title: map["title"],
    desc: map["desc"],
    priority: map["priority"],
    category: map["category"],
    notes: map["notes"],
    startTime: map["start_time"],
    endTime: map["end_time"],
    status: map["status"],
    pin: map["pin"],
    date: map["date"],
  );
}
