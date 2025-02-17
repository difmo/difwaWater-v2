import 'dart:ui'; // Import for BackdropFilter
import 'package:difwa/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:lottie/lottie.dart'; // Import for Lottie

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false; // Flag to show loader

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/bgimage/top.svg',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          // Bottom background image
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/bgimage/bottom.svg',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          // Main content (Form, etc.)
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Image
                    SvgPicture.asset(
                      'assets/logos/difwalogo1.svg',
                      height: 100, // Adjust height as needed
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Login Now",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: AppColors.primary,
                        height: 1.2,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    // Email Field
                    CommonTextField(
                      controller: _emailController,
                      inputType: InputType.email,
                      onChanged: (String) {},
                      label: 'Email',
                      hint: 'Enter Your Email',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    // Password Field
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
                    // Login Button
                    SizedBox(
                      width: 140,
                      child: CustomButton(
                        baseTextColor: ThemeConstants.whiteColor,
                        onPressed: () async {
                          setState(() {
                            isLoading = true; // Show loader
                          });

                          await authController.loginwithemail(
                              _emailController.text, _passwordController.text);

                          setState(() {
                            isLoading = false; // Hide loader after login
                          });
                        },
                        text: 'Login',
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Forgot Password and Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(top: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.login);
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Loader + Blur Effect (shown when isLoading is true)
          if (isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur effect
                child: Container(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                  child: Center(
                    child: Lottie.asset(
                      'assets/lottie/loader.json', // Path to your Lottie file
                      width: 200, // Set width of the animation
                      height: 200, // Set height of the animation
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
