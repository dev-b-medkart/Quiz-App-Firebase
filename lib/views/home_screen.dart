import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_page_controller.dart';
import '../controllers/login_controller.dart';
import 'create_quiz_screen.dart';
import 'play_quiz_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final homeController = Get.put(HomeController());
  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Minimal AppBar with primary actions
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Quizzes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Create Quiz Button
          IconButton(
            onPressed: () {
              Get.to(() => CreateQuizPage());
            },
            icon: const Icon(Icons.add, color: Colors.green),
            tooltip: "Create a new quiz",
          ),
          // Logout Button
          IconButton(
            onPressed: () {
              loginController.handleLogout();
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
            tooltip: "Log out",
          ),
        ],
      ),
      // Main content
      body: Obx(() {
        if (homeController.quizzes.isEmpty) {
          return const Center(child: Text("No Quizzes Created!!"));
        }
        return ListView.builder(
          itemCount: homeController.quizzes.length,
          itemBuilder: (context, index) {
            final quiz = homeController.quizzes[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  homeController.playQuiz(quiz);
                  Get.to(() => PlayQuizPage());
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4,
                  color: const Color(0xFFF3F4F6),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Quiz Icon
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF57955C).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.quiz, color: Color(0xFF57955C), size: 36),
                        ),
                        const SizedBox(width: 16),
                        // Quiz Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quiz.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${quiz.questions.length} Questions',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF8E8E8E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Action Buttons for each quiz
                        Row(
                          children: [
                            Tooltip(
                              message: "Play Quiz",
                              child: InkWell(
                                onTap: () {
                                  homeController.playQuiz(quiz);
                                  Get.to(() => PlayQuizPage());
                                },
                                borderRadius: BorderRadius.circular(50),
                                splashColor: Colors.greenAccent.withOpacity(0.2),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF57955C).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.play_arrow, color: Color(0xFF57955C), size: 30),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Tooltip(
                              message: "Delete Quiz",
                              child: InkWell(
                                onTap: () => homeController.deleteQuiz(quiz.title),
                                borderRadius: BorderRadius.circular(50),
                                splashColor: Colors.redAccent.withOpacity(0.2),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC84F4F).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.delete, color: Color(0xFFC84F4F), size: 28),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
      // Custom Bottom Navigation Bar with User Profile and Navigation Items
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Obx(() {
          final user = loginController.user.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Home Navigation (current page)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.home, color: Colors.blue),
                  SizedBox(height: 4),
                  Text(
                    'Home',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              // Profile Navigation: Display user profile info
              if (user != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoURL ?? ''),
                      radius: 20,
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.providerData.isNotEmpty
                          ? user.providerData[0].displayName ?? "Anonymous"
                          : "Anonymous",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),
              // Additional Navigation Item (e.g., Settings)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.settings, color: Colors.grey),
                  SizedBox(height: 4),
                  Text(
                    'Settings',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controllers/home_page_controller.dart';
// import '../controllers/login_controller.dart';
// import 'create_quiz_screen.dart';
// import 'play_quiz_screen.dart';
//
// class HomePage extends StatelessWidget {
//   HomePage({super.key});
//   final controller = Get.put(HomeController());
//   final loginController =
//       Get.find<LoginController>(); // Initialize LoginController
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Center(child: Text('Quizzes')),
//       //   actions: [
//       //     // Logged-in user details in AppBar
//       //     Obx(() {
//       //       final user = loginController.user.value;
//       //       return user != null
//       //           ? Row(
//       //               children: [
//       //                 CircleAvatar(
//       //                   backgroundImage: NetworkImage(user.photoURL ?? ''),
//       //                   radius: 20,
//       //                 ),
//       //                 const SizedBox(width: 8),
//       //                 Text(
//       //                   user.providerData[0].displayName ?? "Anonymous",
//       //                   style: const TextStyle(fontSize: 16),
//       //                 ),
//       //                 const SizedBox(width: 8),
//       //               ],
//       //             )
//       //           : const SizedBox
//       //               .shrink(); // If user is not logged in, do nothing
//       //     }),
//       //     IconButton(
//       //       onPressed: () {
//       //         Get.to(() => CreateQuizPage());
//       //       },
//       //       icon: const Icon(Icons.add),
//       //     ),
//       //     IconButton(
//       //       onPressed: () {
//       //         loginController.handleLogout(); // Call the logout logic here
//       //       },
//       //       icon: const Icon(Icons.exit_to_app),
//       //     ),
//       //   ],
//       // ),
//       appBar: AppBar(
//         backgroundColor: Colors.white, // Cleaner background
//         elevation: 5, // Subtle shadow for modern feel
//         title: const Text(
//           'Quizzes',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true, // Center the title for better alignment
//         actions: [
//           // Logged-in user details in AppBar
//           Obx(() {
//             final user = loginController.user.value;
//             return user != null
//                 ? Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Profile Picture with Border
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(user.photoURL ?? ''),
//                     radius: 22,
//                     backgroundColor: Colors.grey.shade200,
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     user.providerData[0].displayName ?? "Anonymous",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                 ],
//               ),
//             )
//                 : const SizedBox.shrink(); // If user is not logged in, do nothing
//           }),
//
//           // Add Quiz Button
//           IconButton(
//             onPressed: () {
//               Get.to(() => CreateQuizPage());
//             },
//             icon: const Icon(
//               Icons.add,
//               color: Colors.green,
//             ),
//             tooltip: "Create a new quiz", // Provide a tooltip for better UX
//           ),
//
//           // Logout Button
//           IconButton(
//             onPressed: () {
//               loginController.handleLogout(); // Call the logout logic here
//             },
//             icon: const Icon(
//               Icons.exit_to_app,
//               color: Colors.red,
//             ),
//             tooltip: "Log out", // Tooltip for logout for better UX
//           ),
//         ],
//       ),
//
//       body: Obx(
//         () {
//           if (controller.quizzes.isEmpty) {
//             return const Center(
//               child: Text("No Quizzes Created!!"),
//             );
//           }
//           return ListView.builder(
//             itemCount: controller.quizzes.length,
//             itemBuilder: (context, index) {
//               final quiz = controller.quizzes[index];
//               return Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     controller.playQuiz(quiz);
//                     Get.to(() => PlayQuizPage());
//                   },
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16.0),
//                     ),
//                     elevation: 4,
//                     color: const Color(0xFFF3F4F6),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 16.0, horizontal: 16.0),
//                       child: Row(
//                         children: [
//                           // Quiz Icon
//                           Container(
//                             height: 60,
//                             width: 60,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF57955C).withOpacity(0.1),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(Icons.quiz,
//                                 color: Color(0xFF57955C), size: 36),
//                           ),
//                           const SizedBox(width: 16),
//
//                           // Quiz Title
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   quiz.title,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF2C2C2C),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   '${quiz.questions.length} Questions',
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                     color: Color(0xFF8E8E8E),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           // Action Buttons
//                           Row(
//                             children: [
//                               Tooltip(
//                                 message: "Play Quiz",
//                                 child: InkWell(
//                                   onTap: () {
//                                     controller.playQuiz(quiz);
//                                     Get.to(() => PlayQuizPage());
//                                   },
//                                   borderRadius: BorderRadius.circular(50),
//                                   splashColor:
//                                       Colors.greenAccent.withOpacity(0.2),
//                                   child: Container(
//                                     padding: const EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFF57955C)
//                                           .withOpacity(0.1),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(Icons.play_arrow,
//                                         color: Color(0xFF57955C), size: 30),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Tooltip(
//                                 message: "Delete Quiz",
//                                 child: InkWell(
//                                   onTap: () =>
//                                       controller.deleteQuiz(quiz.title),
//                                   borderRadius: BorderRadius.circular(50),
//                                   splashColor:
//                                       Colors.redAccent.withOpacity(0.2),
//                                   child: Container(
//                                     padding: const EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFC84F4F)
//                                           .withOpacity(0.1),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(Icons.delete,
//                                         color: Color(0xFFC84F4F), size: 28),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
