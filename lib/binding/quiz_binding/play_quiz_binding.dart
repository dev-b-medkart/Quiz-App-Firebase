import 'package:get/get.dart';
import 'package:quiz_app_firebase/controllers/home_page_controller.dart';

class PlayQuizController implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayQuizController>(() => PlayQuizController());
    Get.lazyPut<HomeController>(() => HomeController());
  }


}