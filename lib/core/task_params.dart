class TaskParams {
  final String title;
  final String desc;
  final String priority;
  final String category;
  final String notes;
  final int status;
  final int pin;
  final String startTime;
  final String endTime;
  final String date;

  TaskParams({
    required this.title,
    required this.desc,
    required this.priority,
    required this.category,
    required this.notes,
    required this.status,
    required this.pin,
    required this.startTime,
    required this.endTime,
    required this.date,
  });
}
