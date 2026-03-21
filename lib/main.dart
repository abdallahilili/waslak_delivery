import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/config/supabase_config.dart';
import 'shared/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'core/bindings/initial_binding.dart';
import 'modules/auth/views/pages/login_page.dart';
import 'modules/home/views/pages/home_page.dart';
import 'modules/dashboard/views/dashboard_page.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('fr', null);
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
      initialBinding: InitialBinding(),
      initialRoute: Routes.LOGIN,
      getPages: [
        GetPage(
          name: Routes.LOGIN,
          page: () => const LoginPage(),
        ),
        GetPage(
          name: Routes.HOME, 
          page: () => const HomePage()
        ),
        GetPage(
          name: Routes.DASHBOARD, 
          page: () => const DashboardPage()
        ),
      ],
    );
  }
}
