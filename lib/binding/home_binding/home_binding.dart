import 'package:get/get.dart';
import 'package:quiz_app_firebase/controllers/home_page_controller.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }


}