import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user = Rx<User?>(null);
  late final StreamSubscription<User?> _authListener;

  @override
  void onInit() {
    super.onInit();
    _authListener = _auth.authStateChanges().listen((User? event) {
      user.value = event;
      print("User value: -----------------${user.value?.providerData[0].displayName}\n\n");
      print("User uid value: -----------------${user.value}\n\n");

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

      // await _auth.signInWithCredential(credential);
      //
      //
      //
      //



      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentReference userDocRef =
          _firestore.collection('users').doc(user?.uid);
      final DocumentSnapshot userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        // Create the user document
        await userDocRef.set({
          'uid': user?.uid,
          'displayName': user?.displayName,
          'email': user?.email,
          'photoUrl': user?.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          // Add any additional fields as needed
        });
        print("-------------------------------New user added to Firestore");
      } else {
        // Optionally update user details if needed
        await userDocRef.update({
          'lastSignIn': FieldValue.serverTimestamp(),
        });
        print("-------------------------------Existing user signed in and updated in Firestore");
      }
    } catch (error) {
      print("-------------------------------Error during Google Sign-In: ${error.toString()}");
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
