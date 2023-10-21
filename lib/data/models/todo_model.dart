class TodoModel {
  String? todoType;
  String? todoName;
  String? todoDate;
  String? todoTime;
  List<String>? todoSubTask;
  String? todoCategory;
  String? todoAddDetails;
  bool? todoIsDue;
  bool? todoIsCompleted;
  String? todoFullDate;

  TodoModel({
    this.todoType,
    this.todoName,
    this.todoDate,
    this.todoTime,
    this.todoSubTask,
    this.todoCategory,
    this.todoAddDetails,
    this.todoIsDue,
    this.todoIsCompleted,
    this.todoFullDate,
  });

  // Create a factory constructor to convert from JSON
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    List<String> subTasks = (json['todoSubTask'] as List).cast<String>();

    return TodoModel(
      todoType: json['todoType'],
      todoName: json['todoName'],
      todoDate: json['todoDate'],
      todoTime: json['todoTime'],
      todoSubTask: subTasks,
      todoCategory: json['todoCategory'],
      todoAddDetails: json['todoAddDetails'],
      todoIsDue: json['todoIsDue'],
      todoIsCompleted: json['todoIsCompleted'],
      todoFullDate: json['todoFullDate'],
    );
  }

  // Create a method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'todoType': todoType,
      'todoName': todoName,
      'todoDate': todoDate,
      'todoTime': todoTime,
      'todoSubTask': todoSubTask,
      'todoCategory': todoCategory,
      'todoAddDetails': todoAddDetails,
      'todoIsDue': todoIsDue,
      'todoIsCompleted': todoIsCompleted,
      'todoFullDate': todoFullDate,
    };
  }
}
