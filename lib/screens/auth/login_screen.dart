import 'dart:ui'; // Import for BackdropFilter
import 'package:difwa/config/app_color.dart';
import 'package:difwa/config/app_styles.dart';
import 'package:difwa/utils/validators.dart';
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
  // bool isLoading = false; // Flag to show loader

  final authController = Get.find<AuthController>();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top background image
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: SvgPicture.asset(
          //     'assets/bgimage/top.svg',
          //     fit: BoxFit.cover,
          //     width: MediaQuery.of(context).size.width,
          //   ),
          // ),
          // Bottom background image
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: SvgPicture.asset(
          //     'assets/bgimage/bottom.svg',
          //     fit: BoxFit.cover,
          //     width: MediaQuery.of(context).size.width,
          //   ),
          // ),
          // Main content (Form, etc.)
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30.0, left: 16, right: 16, bottom: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Image
                    SvgPicture.asset(
                      'assets/logos/difwalogo1.svg',
                      height: 100, // Adjust height as needed
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Welcome Back! ",
                      style: AppStyle.headingBlack.copyWith(
                        fontSize: isSmallScreen ? 20 : 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Log in to order water instantly or \n manage your vendor account.",
                      style: AppStyle.greyText18.copyWith(
                        fontSize: isSmallScreen ? 14 : 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    // Email Field
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
                        validator: Validators
                            .validateEmail, // Apply validation function
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Password Field
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
                        validator: Validators
                            .validatePassword, // Apply validation function
                      ),
                    ),
                    // const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.signUp);
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.logosecondry,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: CustomButton(
                        baseTextColor: ThemeConstants.whiteColor,
                        onPressed: () async {
                          if (_formKeyEmail.currentState!.validate() &&
                              _formKeyPassword.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
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
                                isLoading = false;
                              }
                            } catch (e) {
                              print("Error during login: $e");
                              Get.snackbar("Error", "Something went wrong");
                              isLoading = false;
                            } finally {
                              setState(() {
                                isLoading = false; // Stop loader after login
                              });
                            }
                          }
                        },
                        width: double.infinity,
                        text: 'SignIn',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.only(top: 00),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.signUp);
                            },
                            child: const Text(
                              'Sign Up Now!',
                              style: TextStyle(
                                color: AppColors.logosecondry,
                              ),
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
                filter:
                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur effect
                child: Container(
                  // ignore: deprecated_member_use
                  color:
                      Colors.black.withOpacity(0.5), // Semi-transparent overlay
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
