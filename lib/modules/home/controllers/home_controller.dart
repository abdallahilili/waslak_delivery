import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final authController = Get.find<AuthController>();

  void logout() {
    authController.logout();
  }
}
