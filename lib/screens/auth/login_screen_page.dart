import 'package:difwa/config/app_color.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/widgets/custom_inputfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:difwa/routes/app_routes.dart'; // Assuming you have routes setup

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  // Assuming your authController is already set up via GetX dependency injection
  final authController = Get.find<AuthController>(); // Example if using GetX

  // This can be a real validation function, here it is just for demonstration.
  bool isValidEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  bool isValidPassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  // Handle email login
  void _loginwithmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate email format
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

    // Strong password validation
    if (password.isEmpty || password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters long'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check for uppercase, lowercase, number, and special character
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
      await authController.loginwithemail(email, password);
      setState(() {
        isLoading = false;
      });
      // Navigate after successful login
      // Get.toNamed(AppRoutes.userbottom); // Example route, change to your need
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: AppColors.primary),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 20),
            // Logo or other welcome information
            Center(
              child: Image.asset(
                'assets/images/gb.png', // Replace with your app logo
                height: 300, // Adjust the size of the logo
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Email TextField
            CommonTextField(
              controller: _emailController,
              inputType: InputType.email,
              onChanged: (String) {},
              label: 'Email',
              hint: 'Enter Your Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 16),

            // Password TextField
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
              child: ElevatedButton(
                onPressed: isLoading ? null : _loginwithmail,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Forgot Password and Register links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Forgot password link
                TextButton(
                  onPressed: () {
                    // Navigate to Forgot Password page
                    Get.toNamed(
                        AppRoutes.login); // Assuming you have this route
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                // Register link
                TextButton(
                  onPressed: () {
                    // Navigate to Register page
                    Get.toNamed(
                        AppRoutes.login); // Assuming you have a register route
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
