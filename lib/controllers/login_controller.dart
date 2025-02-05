// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// class LoginController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   var user = (null as User?).obs;
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     _auth.authStateChanges().listen((event) {
//       user.value = event;
//       print("user value ${user.value}");
//     });
//   }
//
//   Future<void> handleGoogleSignIn() async{
//     try {
//       GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
//       _auth.signInWithProvider(googleAuthProvider);
//     } catch (error) {
//       print("++++++++=");
//       print(error);
//     }
//   }
//   Future<void> handleLogout() async{
//     try {
//       await _auth.signOut(); // Sign out the current user
//       print("User logged out successfully");
//     } catch (error) {
//       print("Error during logout: $error");
//     }
//   }
// }

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user = Rx<User?>(null);
  late final StreamSubscription<User?> _authListener;

  @override
  void onInit() {
    super.onInit();
    _authListener = _auth.authStateChanges().listen((event) {
      user.value = event;
      print("User value: ${user.value}");

      if (user.value != null) {
        print("logged in ");
        Future.delayed(Duration.zero, () {
          Get.offAllNamed('/'); // Ensure navigation happens asynchronously
        });
      }

    });
  }

  Future<void> handleGoogleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (error) {
      print("Error during Google Sign-In: ${error.toString()}");
    }
  }

  Future<void> handleLogout() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut(); // Also sign out from Google
      print("User logged out successfully");
      Get.offAllNamed('/login'); // Ensure navigation happens asynchronously


    } catch (error) {
      print("Error during logout: $error");
    }
  }

  @override
  void onClose() {
    _authListener.cancel();
    super.onClose();
  }
}
