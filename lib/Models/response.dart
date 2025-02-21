//Response Model
class Response {
  final int questionIndex;
  final String answer;
  final DateTime timestamp;

  Response({
    required this.questionIndex,
    required this.answer,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    questionIndex: json['question_index'],
    answer: json['response'],
    timestamp: DateTime.parse(json['timestamp']),
  );

  Map<String, dynamic> toJson() => {
    'question_index': questionIndex,
    'response': answer,
    'timestamp': timestamp.toIso8601String(),
  };
}