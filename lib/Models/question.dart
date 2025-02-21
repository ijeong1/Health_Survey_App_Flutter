// Question Model
class Question {
  final int index;
  final String text;
  final List<String> options;

  Question({
    required this.index,
    required this.text,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json, int index) => Question(
    index: index,
    text: json['Question'],
    options: List<String>.from(json['Responses']),
  );
}