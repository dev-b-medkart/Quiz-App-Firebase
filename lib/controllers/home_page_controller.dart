import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/question_model.dart';
import '../models/quiz_model.dart';
import '../services/hive_service.dart';

class HomeController extends GetxController {
  var quizzes = <Quiz>[].obs;

  @override
  void onInit() async {
    // TODO: implement onInit

    print('Recall home init');
    super.onInit();
    HiveService.init();
    await loadQuizzes();
  }

  @override
  void onReady() {
    print("Home controller ready");
    super.onReady();
  }

  @override
  void refresh() {
    print("Home controller refresh");
    super.refresh();
  }

  Future<void>loadQuizzes() async {
    // quizzes.value = HiveService.getQuizzes();
    try {
      String? userUid = FirebaseAuth.instance.currentUser?.uid;
      if (userUid == null) {
        print("User is not logged in");
        quizzes.value = [];
        return;
      }

      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      QuerySnapshot quizSnapshot = await _firestore
          .collection('users')
          .doc(userUid)
          .collection('quizzes')
          .get();

      quizzes.value = quizSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Quiz(
          uniqueId: doc.id, // Document ID as quiz ID
          title: data['title'] ?? 'Untitled Quiz',
          questions: (data['questions'] as List<dynamic>).map((q) {
            return Question(
              text: q['question'] ?? '',
              options: List<String>.from(q['options'] ?? []),
              correctOptionIndex: (q['correctOption'] ?? 1) - 1,
            );
          }).toList(),
        );
      }).toList();

      return;
    } catch (e) {
      print("Error fetching quizzes: $e");
      quizzes.value = [];
      return;
    }
  }

  void deleteQuiz(String quizTitle) {
    HiveService.deleteQuiz(quizTitle);
    loadQuizzes();
  }

  Quiz? quiz;
  int currentQuizIndex = 0;
  var userAnswers = <int>[];
  int score = 0;

  void submitQuiz(List<int> userAnswers) {
    this.userAnswers = userAnswers;
    for (int i = 0; i < (quiz?.questions ?? []).length; i++) {
      if (userAnswers[i] == quiz?.questions[i].correctOptionIndex) {
        score++;
      }
    }
  }

  void resetScore() {
    score = 0;
  }

  void playQuiz(Quiz quizData) {
    // quiz=quiz1;
    // print(" quizData $quizData");
    quiz = quizData;
  }

  void updateIndex(int index) {
    currentQuizIndex = index;
  }
}
