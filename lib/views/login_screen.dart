import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_firebase/controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueAccent.shade100, Colors.blueAccent.shade400],
            ),
          ),
          child: Obx(() {
            final loginController = Get.find<LoginController>();
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: loginController.user.value == null
                    ? ElevatedButton(
                        onPressed: () async{
                         await loginController.handleGoogleSignIn();
                              if(loginController.user.value!=null){
                                Get.offAllNamed('/');
                              }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: Colors.blueAccent.withOpacity(0.5),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      )
                    : Center(
                        child: Text('Logged in'),
                      ),
              ),
            );
          })),
    );
  }
}
