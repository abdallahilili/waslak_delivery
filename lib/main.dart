import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/config/supabase_config.dart';
import 'shared/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'modules/auth/bindings/auth_binding.dart';
import 'modules/auth/views/login_page.dart';
import 'modules/home/views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseConfig.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gestion Livreurs',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: AuthBinding(),
      initialRoute: Routes.LOGIN,
      getPages: [
        GetPage(
          name: Routes.LOGIN,
          page: () => const LoginPage(),
          binding: AuthBinding(),
        ),
        GetPage(name: Routes.HOME, page: () => const HomePage()),
      ],
    );
  }
}
