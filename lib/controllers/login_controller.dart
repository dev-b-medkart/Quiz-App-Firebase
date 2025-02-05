import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user = (null as User?).obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _auth.authStateChanges().listen((event) {
      user.value = event;
      print("user value ${user.value}");
    });
  }

  Future<void> handleGoogleSignIn() async{
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleAuthProvider);
    } catch (error) {
      print("++++++++=");
      print(error);
    }
  }
  Future<void> handleLogout() async{
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleAuthProvider);
    } catch (error) {
      print("++++++++=");
      print(error);
    }
  }
}
