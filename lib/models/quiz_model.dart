import 'package:hive/hive.dart';
import 'question_model.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
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
  String get uniqueId {
    // Convert hashCode to a string
    String rawId = hashCode.toString();

    // Apply SHA-256 hashing
    var bytes = utf8.encode(rawId); // Convert string to bytes
    var digest = sha256.convert(bytes); // Compute SHA-256 hash

    return digest.toString(); // Return hashed ID
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'Quiz Title: $title\nQuestions:\n${questions.map((q) => q.toString()).join("\n")}';
  }
}
