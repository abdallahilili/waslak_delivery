import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../../../../core/utils/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController controller = Get.find<AuthController>();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.delivery_dining,
                  size: 80, 
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'Gestion Livreurs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 48),
                AppInput(
                  label: 'Téléphone',
                  hint: 'Ex: 40123456',
                  controller: _phoneController,
                  validator: Validators.requiredField,
                  keyboardType: TextInputType.phone,
                ),
                AppInput(
                  label: 'Mot de passe',
                  hint: '******',
                  controller: _passwordController,
                  validator: Validators.requiredField,
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                Obx(() => Column(
                  children: [
                    AppButton(
                      text: 'Se connecter',
                      isLoading: controller.isLoading.value,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.login(
                            _phoneController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: controller.isLoading.value ? null : () {
                        if (_formKey.currentState!.validate()) {
                          controller.signUp(
                            _phoneController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        }
                      },
                      child: const Text('Créer un compte'),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
