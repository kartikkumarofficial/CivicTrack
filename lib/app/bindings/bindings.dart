import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/nav_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/user_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {

    Get.put(UserController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(NavController(), permanent: true);
    Get.put(ThemeController(), permanent: true);

}
}