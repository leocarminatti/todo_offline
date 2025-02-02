class Task {
  final String id;
  final String title;
  final String description;
  bool isChecked;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isChecked = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isChecked,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
