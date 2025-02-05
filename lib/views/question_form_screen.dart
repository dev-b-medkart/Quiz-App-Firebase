import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_quiz_controller.dart';
import '../models/question_model.dart';
import '../models/quiz_model.dart';

class QuestionFormPage extends StatefulWidget {


  const QuestionFormPage({
    super.key,
  });

  @override
  State<QuestionFormPage> createState() => _QuestionFormPageState();
}

class _QuestionFormPageState extends State<QuestionFormPage> {
  late PageController _pageController;
  late List<Question> _questions;
  final controller=Get.find<CreateQuizController>();

  Quiz? quizData;
  int numOfQuestion = 0;
  @override
  void initState() {
    super.initState();
     quizData = controller.quiz;
    _pageController = PageController();
    numOfQuestion = int.parse(controller.numQuestionsController.text);
    _questions = List.generate(
      numOfQuestion,
      (index) => Question(
        text: '',
        options: ['', '', '', ''],
        correctOptionIndex: -1,
      ),
    );
  }

  void _saveQuestion(
      int index, String text, List<String> options, int correctOptionIndex) {
    setState(() {
      print("object $text");
      _questions[index] = Question(
        text: text,
        options: options,
        correctOptionIndex: correctOptionIndex,
      );
    });
  }

  bool _isQuizComplete() {
    for (var question in _questions) {
      if (question.text.isEmpty ||
          question.options.any((option) => option.isEmpty) ||
          question.correctOptionIndex == -1) {
        return false;
      }
    }
    return true;
  }

  void _submitQuiz() {
    if (_isQuizComplete()) {
      controller.updateQuiz(_questions);
      quizData?.questions = _questions;
      Get.offAllNamed('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all questions before submitting."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  ValueNotifier<int> currentPage = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Questions'),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (value) {
          currentPage.value = value;
        },
        itemCount: numOfQuestion,
        itemBuilder: (context, index) {
          return QuestionForm(
            questionIndex: index,
            question: _questions[index],
            onSave: _saveQuestion,
          );
        },
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: currentPage,
        builder: (context, value, child) {
          // print("VALUE____________$value");
          if (value == numOfQuestion- 1) {
            return FloatingActionButton(
              onPressed: _submitQuiz,
              tooltip: 'Submit Quiz',
              child: const Icon(Icons.check),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

class QuestionForm extends StatefulWidget {
  final int questionIndex;
  final Question question;
  final Function(int, String, List<String>, int) onSave;

  const QuestionForm({
    super.key,
    required this.questionIndex,
    required this.question,
    required this.onSave,
  });

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  late TextEditingController _questionController;
  late List<TextEditingController> _optionControllers;
  int? _selectedOptionIndex;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.text);
    _optionControllers = List.generate(4,
        (index) => TextEditingController(text: widget.question.options[index]));
    _selectedOptionIndex = widget.question.correctOptionIndex == -1
        ? null
        : widget.question.correctOptionIndex;
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSave() {
    widget.onSave(
      widget.questionIndex,
      _questionController.text,
      _optionControllers.map((controller) => controller.text).toList(),
      _selectedOptionIndex ?? -1, // ✅ Use -1 as a fallback
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Question ${widget.questionIndex + 1}'),
          TextField(
            controller: _questionController,
            decoration: const InputDecoration(labelText: 'Question Text'),
            onChanged: (_) => _onSave(),
          ),
          ...List.generate(4, (index) {
            return TextField(
              controller: _optionControllers[index],
              decoration: InputDecoration(
                  labelText: 'Option ${String.fromCharCode(65 + index)}'),
              onChanged: (_) => _onSave(),
            );
          }),
          DropdownButtonFormField<int>(
            value: _selectedOptionIndex,
            onChanged: (value) {
              setState(() {
                _selectedOptionIndex = value;
              });
              _onSave();
            },
            items: List.generate(4, (index) {
              return DropdownMenuItem(
                value: index,
                child: Text('Option ${String.fromCharCode(65 + index)}'),
              );
            }),
            decoration: const InputDecoration(labelText: 'Correct Answer'),
          ),
        ],
      ),
    );
  }
}
