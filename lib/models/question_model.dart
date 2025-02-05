import 'package:hive/hive.dart';
part 'question_model.g.dart';

@HiveType(typeId: 0)
class Question{
  @HiveField(0)
  String text;

  @HiveField(1)
  List<String>options;

  @HiveField(2)
  int correctOptionIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctOptionIndex,
});
  @override
  String toString() {
    // TODO: implement toString
    return 'Q: $text\nOptions: ${options.asMap().entries.map((e) => '${String.fromCharCode(65 + e.key)}) ${e.value}').join(", ")}\nCorrect: ${String.fromCharCode(65 + correctOptionIndex)}) ${options[correctOptionIndex]}';

  }
}