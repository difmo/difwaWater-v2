import 'package:difwa/config/app_color.dart';
import 'package:difwa/config/app_styles.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/screens/auth/login_screen_page.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_inputfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileNumberPage extends StatefulWidget {
  @override
  _MobileNumberPageState createState() => _MobileNumberPageState();
}

class _MobileNumberPageState extends State<MobileNumberPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  bool isLoading = false;
  int _selectedTabIndex = 0; // This controls which tab is selected
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Handle mobile number login
  void _handleRegister() async {
    final phoneNumber = phoneController.text.trim();
    final name = nameController.text.trim();

    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final fullPhoneNumber = '+91$phoneNumber';

    try {
      await authController.login(fullPhoneNumber, name);
      setState(() {
        isLoading = false;
      });
      // Navigate after successful login (if necessary)
      Get.toNamed(AppRoutes.userbottom); // Example route, change to your need
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


  
 




  // Handle email login
  void _handlemail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
 

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
      await authController.registerwithemail(email, password);
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
                    SizedBox(
                    
                      child: Image.asset(
                      'assets/images/gb.png', // Replace with your app logo
                      height: 300, // Adjust the size of the logo
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                    ),
                    Text(
                      "Enter your details",
                      style: AppStyle.headingBlack.copyWith(
                        fontSize: isSmallScreen ? 20 : 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Please enter your name and the required verification details",
                      style: AppStyle.greyText18.copyWith(
                        fontSize: isSmallScreen ? 14 : 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                
                    // Custom Tabs Section (Instead of TabBar)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCustomTab("Mobile Number", 0),
                        _buildCustomTab("Email", 1),
                      ],
                    ),
                    SizedBox(height: 20),
                
                    // Tab Views (Show based on the selected tab index)
                    if (_selectedTabIndex == 0) ...[
                      // Mobile Number Tab View
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            CommonTextField(
                              controller: nameController, inputType: InputType.name, onChanged: (String ) {  }, label: 'Name', hint: 'Enter Your Name',
                              icon: Icons.person,
                              
                            ),
                            SizedBox(height: 20),
                            Column(
                              children: [
                               CommonTextField(
                            controller: phoneController, inputType: InputType.phone, onChanged: (String ) {  }, label: 'Mobile No.', hint: 'Enter Your Mobile No.',
                              icon: Icons.phone,
                            ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: isSmallScreen ? 50 : 50,
                                  child: CustomButton(
                                    onPressed: _handleRegister, text: 'Register',
                                    
                                   
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ] else if (_selectedTabIndex == 1) ...[
                      // Email Tab View
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            CommonTextField(
                              controller: nameController, inputType: InputType.email, onChanged: (String ) {  }, label: 'Name', hint: 'Enter Your Name',
                              icon: Icons.person,
                            ),
                            SizedBox(height: 20),
                            Column(
                              children: [
                                CommonTextField(
                                  controller: emailController,
                                  inputType: InputType.email,
                                  onChanged: (String ) {  },
                                  label: 'Email',
                                  hint: 'Enter Your Email',
                                  icon: Icons.email,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Column(
                              children: [
                                CommonTextField(
                                  controller: passwordController,
                                  inputType: InputType.visiblePassword,
                                  onChanged: (String ) {  },
                                  label: 'Password',
                                  hint: 'Enter Your Password',
                                  icon: Icons.lock,
                                  suffixIcon: Icons.visibility_off,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 140,
                                  height: isSmallScreen ? 50 : 50,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _handlemail,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                AppColors.mywhite),
                                          )
                                        : Text("Register",
                                            style: AppStyle.headingWhite),
                                  ),
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
                                                const LoginScreenPage())); // Forgot password functionality
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
  Widget _buildCustomTab(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _selectedTabIndex == index
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                _selectedTabIndex == index ? Colors.white : AppColors.primary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
