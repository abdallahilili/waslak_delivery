import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gestion_livreurs/routes/app_routes.dart';
class AuthController extends GetxController {
  final _client = Supabase.instance.client;
  
  final isLoading = false.obs;
  
  @override
  void onReady() {
    super.onReady();
    _handleAuthRedirect();
  }

  void _handleAuthRedirect() {
    final session = _client.auth.currentSession;
    if (session != null) {
      Get.offAllNamed(Routes.HOME);
    } else {
      // Stay on login or redirect there
    }
  }

  Future<void> login(String phone, String password) async {
    try {
      isLoading.value = true;
      // Convert phone to fake email as per requirement
      final email = '$phone@livreur.app';
      
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        Get.offAllNamed(Routes.HOME);
      }
    } on AuthException catch (e) {
      Get.snackbar('Erreur Login', e.message);
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue lors de la connexion');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String phone, String password) async {
    try {
      isLoading.value = true;
      final email = '$phone@livreur.app';
      
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.session != null) {
        Get.offAllNamed(Routes.HOME);
        Get.snackbar('Succès', 'Compte créé avec succès');
      } else if (response.user != null) {
        Get.snackbar('Succès', 'Compte créé. Veuillez vérifier vos emails (si activé) ou vous connecter.');
      }
    } on AuthException catch (e) {
      Get.snackbar('Erreur Inscription', e.message);
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue lors de l\'inscription');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
  
  User? get user => _client.auth.currentUser;
}
