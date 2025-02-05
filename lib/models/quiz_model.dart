import 'package:hive/hive.dart';
import 'question_model.dart';
part 'quiz_model.g.dart';

@HiveType(typeId: 1)
class Quiz {
  @HiveField(0)
  String title;

  @HiveField(1)
  List<Question> questions;

  Quiz({
    required this.title,
    required this.questions,
  });
  @override
  String toString() {
    // TODO: implement toString
    return 'Quiz Title: $title\nQuestions:\n${questions.map((q) => q.toString()).join("\n")}';
  }
}
