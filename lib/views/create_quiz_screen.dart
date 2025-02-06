import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/create_quiz_controller.dart';
import '../utils/validations.dart';
import 'question_form_screen.dart';

class CreateQuizPage extends StatelessWidget {
  CreateQuizPage({super.key});

  final controller=Get.put(CreateQuizController());


  @override
  Widget build(BuildContext context) {
    // print('isAutoValidActive $isAutoValidActive');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: controller.formKey,
            autovalidateMode: controller.isAutoValidActive.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  "Set Quiz Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Title of Quiz
                const Text(
                  "Title of Quiz:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.titleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText:
                        "Enter the title of the quiz", // Updated hint text
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(
                        Icons.title), // Changed icon to represent title input
                  ),
                  validator: Validations.titleValidator,
                ),
                const SizedBox(height: 16), // Number of Questions
                const Text(
                  "Number of Questions:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.numQuestionsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "Enter number of questions",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.format_list_numbered),
                  ),
                  validator: Validations.numberValidator,
                ),
                const SizedBox(height: 16),

                // Time for the Quiz
                const Text(
                  "Time for the Quiz (minutes):",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.timeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter time in minutes",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.timer),
                    // Show error message
                  ),
                  validator: Validations.numberValidator,
                ),
                const SizedBox(height: 24),

                // Submit Button

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.submitFun(
                        quizCreated: (value) async {

                              Get.toNamed('/QuestionFormPage');


                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Create Quiz",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
