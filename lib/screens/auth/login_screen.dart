import 'package:difwa/config/app_styles.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:difwa/routes/app_routes.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text("Login",style: AppStyle.heading4Black,),
            CommonTextField(
              controller: _emailController,
              inputType: InputType.email,
              onChanged: (String) {},
              label: 'Email',
              hint: 'Enter Your Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _passwordController,
              inputType: InputType.visiblePassword,
              onChanged: (String) {},
              label: 'Password',
              hint: 'Enter Your Password',
              icon: Icons.lock,
              suffixIcon: Icons.visibility_off,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 140,
              child: CustomButton(
                baseTextColor: ThemeConstants.whiteColor,
                onPressed: () async {
                  await authController.loginwithemail(
                      _emailController.text, _passwordController.text);
                },
                text: 'Login',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.login);
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.login);
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
