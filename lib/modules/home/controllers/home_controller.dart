import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final authController = Get.find<AuthController>();

  final _client = Supabase.instance.client;
  
  final livreursCount = 0.obs;
  final placesCount = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      isLoading.value = true;
      
      // Fetch Livreurs Count
      final livreursResponse = await _client
          .from('livreurs')
          .count();
      livreursCount.value = livreursResponse;

      // Fetch Places Count
      final placesResponse = await _client
          .from('places')
          .count();
      placesCount.value = placesResponse;
      
    } catch (e) {
      print('Error fetching home stats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    authController.logout();
  }
}
