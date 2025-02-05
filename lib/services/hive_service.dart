import 'package:hive/hive.dart';

import '../models/quiz_model.dart';

class HiveService {
  static const String quizBoxName = 'quizzes';

//   Open Box
  static Future<void> init() async {
    await Hive.openBox<Quiz>(quizBoxName);
  }

  // Add a Quiz
  static Future<void> addQuiz(Quiz quiz) async {
    final box = Hive.box<Quiz>(quizBoxName);
    await box.put(quiz.title, quiz);
  }
  // Get all quizzes
  static List<Quiz>getQuizzes(){
    final box=Hive.box<Quiz>(quizBoxName);
    return box.values.toList();
  }
  // Get a Quiz
  static Quiz? getQuiz(String title){
    final box=Hive.box<Quiz>(quizBoxName);
    return box.get(title);
  }
  // Delete a Quiz
  static Future<void> deleteQuiz(String title) async{
    final box=Hive.box<Quiz>(quizBoxName);
    await box.delete(title);
  }
}

