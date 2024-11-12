class TodoModel {
  final int id;
  final String content;
  final bool completed;

  TodoModel(this.id, this.content, this.completed);

  TodoModel copyWith({int? id, String? content, bool? completed}) {
    return TodoModel(
        id ?? this.id, content ?? this.content, completed ?? this.completed);
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(json['id'], json['content'], json['completed']);
  }
}