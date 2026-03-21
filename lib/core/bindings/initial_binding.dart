import 'package:get/get.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/home/controllers/home_controller.dart';
import '../../modules/journal/controllers/journal_controller.dart';
import '../../modules/livreurs/controllers/livreur_controller.dart';
import '../../modules/places/controllers/places_controller.dart';
import '../../modules/places/controllers/restaurant_controller.dart';
import '../../modules/dashboard/controllers/dashboard_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Auth controller is usually permanent to keep user state
    Get.put<AuthController>(AuthController(), permanent: true);
    
    // Other controllers can be put as fenix or permanent depending on app needs
    // Given the user request, they want them initialized together.
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<JournalController>(() => JournalController());
    Get.lazyPut<LivreurController>(() => LivreurController());
    Get.lazyPut<PlacesController>(() => PlacesController());
    Get.lazyPut<RestaurantController>(() => RestaurantController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
