import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:difwa/config/app_color.dart';
import 'package:difwa/config/app_styles.dart';
import 'package:difwa/utils/validators.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:difwa/routes/app_routes.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final authController = Get.find<AuthController>();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SvgPicture.asset(
                        'assets/logos/difwalogo1.svg',
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        "Welcome Back!",
                        style: AppStyle.headingBlack.copyWith(
                          fontSize: isSmallScreen ? 22 : 26,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        "Log in to order water instantly or \nmanage your vendor account.",
                        style: AppStyle.greyText18.copyWith(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // Email Input
                          Form(
                            key: _formKeyEmail,
                            child: CommonTextField(
                              controller: _emailController,
                              inputType: InputType.email,
                              onChanged: (String) {
                                _formKeyEmail.currentState!.validate();
                              },
                              label: 'Email',
                              hint: 'Enter Email',
                              icon: Icons.email,
                              validator: Validators.validateEmail,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Password Input
                          Form(
                            key: _formKeyPassword,
                            child: CommonTextField(
                              controller: _passwordController,
                              inputType: InputType.visiblePassword,
                              onChanged: (String) {
                                _formKeyPassword.currentState!.validate();
                              },
                              label: 'Password',
                              hint: 'Enter Password',
                              icon: Icons.lock,
                              suffixIcon: Icons.visibility_off,
                              validator: Validators.validatePassword,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.signUp);
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: AppColors.logosecondry),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Sign In Button
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              onPressed: () async {
                                if (_formKeyEmail.currentState!.validate() &&
                                    _formKeyPassword.currentState!.validate()) {
                                  setState(() => isLoading = true);
                                  try {
                                    bool success =
                                        await authController.loginwithemail(
                                      _emailController.text,
                                      _passwordController.text,
                                      isLoading,
                                    );

                                    if (!success) {
                                      Get.snackbar("Login Failed",
                                          "Invalid email or password.");
                                    }
                                  } catch (e) {
                                    Get.snackbar(
                                        "Error", "Something went wrong");
                                  } finally {
                                    setState(() => isLoading = false);
                                  }
                                }
                              },
                              height: 54,
                              width: double.infinity,
                              text: isLoading ? 'Loading...' : 'Sign In',
                              baseTextColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(color: Colors.black54),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.signUp);
                                },
                                child: const Text(
                                  'Sign Up Now',
                                  style:
                                      TextStyle(color: AppColors.logosecondry),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Loader Animation
          if (isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Lottie.asset(
                      'assets/lottie/loader.json',
                      width: 150,
                      height: 150,
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
