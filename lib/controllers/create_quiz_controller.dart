import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../models/quiz_model.dart';
import '../services/hive_service.dart';

class CreateQuizController extends GetxController {
  var isAutoValidActive = AutovalidateMode.disabled.obs;

  final TextEditingController numQuestionsController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    numQuestionsController.dispose();
    timeController.dispose();
    titleController.dispose();
    super.onClose();
  }

  Quiz? quiz;
  Future<void> submitFun({required ValueChanged<String> quizCreated}) async {
    if (!formKey.currentState!.validate()) {
      isAutoValidActive.value = AutovalidateMode.always;
      return;
    }
    final numQuestions = int.tryParse(numQuestionsController.text)!;
    final quizTime = int.tryParse(timeController.text)!;
    final quizTitle = titleController.text;
    quiz = Quiz(title: quizTitle, questions: []);

    quizCreated.call("Quiz Created");
    // final updatedQuiz =
    //     await Get.to(() => QuestionFormPage(quiz: quiz, numQuestions: numQuestions));
    // await HiveService.addQuiz(updatedQuiz);
    // if(updatedQuiz!=null){
    //   Get.back(result: updatedQuiz);
    // }
  }

  void setIsAutoValidActive(var value) {
    isAutoValidActive = value;
  }

  Future<void> updateQuiz(List<Question> questions) async {
    if (quiz != null) {
      quiz?.questions = questions;
      await HiveService.addQuiz(quiz!);
    }
  }
}
