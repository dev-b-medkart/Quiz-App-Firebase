import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'binding/home_binding/home_binding.dart';
import 'binding/login_binding/login_binding.dart';
import 'firebase_options.dart';
import 'models/question_model.dart';
import 'models/quiz_model.dart';
import 'services/hive_service.dart';
import 'views/create_quiz_screen.dart';
import 'views/home_screen.dart';
import 'views/login_screen.dart';
import 'views/play_quiz_screen.dart';
import 'views/question_form_screen.dart';




Future<void> deleteHiveDatabase() async {
  Directory appDir = await getApplicationDocumentsDirectory();
  String hiveDbPath = appDir.path;

  Directory hiveDir = Directory(hiveDbPath);

  if (await hiveDir.exists()) {
    hiveDir.deleteSync(recursive: true); // Deletes all Hive files
    print("Hive database deleted successfully!");
  }
}














void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await deleteHiveDatabase(); // Delete Hive DB before the app starts

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive using hive_flutter
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(QuizAdapter());

  // Initialize HiveService

  await HiveService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: '/',
          page: () => HomePage(),
          binding: HomeBinding(), // Bind the controller here
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
          binding: LoginBinding(),
        ),
        GetPage(
            name: '/playQuiz',
            page: () => PlayQuizPage(),
            binding: HomeBinding()),
        GetPage(
          name: '/createQuiz',
          page: () => CreateQuizPage(),
        ),
        GetPage(
          name: '/QuestionFormPage',
          page: () => QuestionFormPage(),
        ),
      ],
    );
  }
}
