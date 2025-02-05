import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/quiz_model.dart';

class PlayQuizController extends GetxController {
  var userAnswers = <int>[].obs;
  var userScore = 0.obs;
  var currentPage = 0.obs;
  final PageController pageController = PageController();

  createQuiz(Quiz? quiz) {
    userAnswers.value = List.filled((quiz?.questions ?? []).length, -1);
  }

  void selectAnswer(int questionIndex, int option) {
    userAnswers[questionIndex] = option;
  }
}
