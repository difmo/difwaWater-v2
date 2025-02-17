import 'package:difwa/config/app_styles.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/screens/auth/login_screen.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileNumberPage extends StatefulWidget {
  const MobileNumberPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MobileNumberPageState createState() => _MobileNumberPageState();
}

class _MobileNumberPageState extends State<MobileNumberPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  bool isLoading = false;

  void _handlemail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty ||
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.isEmpty || password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters long'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String passwordPattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    if (!RegExp(passwordPattern).hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authController.signwithemail(email, password);
      setState(() {
        isLoading = false;
      });
  
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log in: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Enter your details",
                      style: AppStyle.headingBlack.copyWith(
                        fontSize: isSmallScreen ? 20 : 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Please enter your name and the required verification details",
                      style: AppStyle.greyText18.copyWith(
                        fontSize: isSmallScreen ? 14 : 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          CommonTextField(
                            controller: nameController,
                            inputType: InputType.email,
                            onChanged: (String) {},
                            label: 'Name',
                            hint: 'Enter Your Name',
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              CommonTextField(
                                controller: emailController,
                                inputType: InputType.email,
                                label: 'Email',
                                hint: 'Enter Your Email',
                                icon: Icons.email,
                                onChanged: (String) {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              CommonTextField(
                                controller: passwordController,
                                inputType: InputType.visiblePassword,
                                // ignore: avoid_types_as_parameter_names
                                onChanged: (String) {},
                                label: 'Password',
                                hint: 'Enter Your Password',
                                icon: Icons.lock,
                                suffixIcon: Icons.visibility_off,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomButton(
                                onPressed: _handlemail,
                                text: 'Register',
                                                      
                                baseTextColor: Colors.white,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Already have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreenPage()));
                                },
                                child: const Text(
                                  'LogIn',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
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
        ],
      ),
    );
  }

  // Custom Tab Widget
}
