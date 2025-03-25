import 'dart:ui';

import 'package:difwa/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:difwa/config/app_styles.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/screens/auth/login_screen.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:difwa/utils/validators.dart';
// import 'package:country_code_picker/country_code_picker.dart';
import 'package:lottie/lottie.dart';

class MobileNumberPage extends StatefulWidget {
  const MobileNumberPage({super.key});

  @override
  _MobileNumberPageState createState() => _MobileNumberPageState();
}

class _MobileNumberPageState extends State<MobileNumberPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggeredController;
  late List<Interval> _itemSlideIntervals;
  late Interval _buttonInterval;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  bool isLoading = false;

  final GlobalKey<FormState> _formKeyPhone = GlobalKey<FormState>();
  String selectedCountryCode = "+91"; // Default country code

  final _formKeyName = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _staggeredController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _createAnimationIntervals();
    _staggeredController.forward();
  }

  void _createAnimationIntervals() {
    _itemSlideIntervals = [];
    for (int i = 0; i < 4; i++) {
      _itemSlideIntervals
          .add(Interval(i * 0.2, (i + 1) * 0.2, curve: Curves.easeIn));
    }

    _buttonInterval = Interval(0.8, 1.0, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _staggeredController.dispose();
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
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/logos/difwalogo1.svg',
                      height: 100,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Create Your Account ",
                      style: AppStyle.headingBlack.copyWith(
                        fontSize: isSmallScreen ? 20 : 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    Text(
                      "Order water with ease or register as a \nvendor to sell. Sign up now!",
                      style: AppStyle.greyText18.copyWith(
                        fontSize: isSmallScreen ? 14 : 18,
                      ),
                      textAlign: TextAlign.center, // Ensure it's center-aligned
                    ),

                    // Text(
                    //   "Order water with ease or register as a vendor to sell.\n Sign up now!",
                    //   style: AppStyle.greyText18.copyWith(
                    //     fontSize: isSmallScreen ? 14 : 18,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    const SizedBox(height: 30),
                    AnimatedBuilder(
                      animation: _staggeredController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _itemSlideIntervals[0]
                              .transform(_staggeredController.value),
                          child: child,
                        );
                      },
                      child: Form(
                        key: _formKeyPhone,
                        child: Row(
                          children: [
                            // CountryCodePicker(
                            //   onChanged: (code) {
                            //     setState(() {
                            //       selectedCountryCode = code.dialCode!;
                            //     });
                            //   },
                            //   initialSelection: 'IN',
                            //   favorite: const ['+91', '+1'],
                            //   showCountryOnly: false,
                            //   showOnlyCountryWhenClosed: false,
                            //   showFlag: false,
                            //   alignLeft: false,
                            // ),
                            Expanded(
                              child: CommonTextField(
                                controller: phoneController,
                                inputType: InputType.phone,
                                label: 'Phone Number',
                                hint: 'Enter Phone Number',
                                showCountryPicker: true,
                                // prefixText: '+91',
                                icon: Icons.phone,
                                onChanged: (String) {
                                  _formKeyPhone.currentState!.validate();
                                },
                                validator: Validators.validatePhone,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _staggeredController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _itemSlideIntervals[1]
                              .transform(_staggeredController.value),
                          child: child,
                        );
                      },
                      child: Form(
                        key: _formKeyName,
                        child: CommonTextField(
                          controller: nameController,
                          inputType: InputType.name,
                          onChanged: (String) {
                            _formKeyName.currentState!.validate();
                          },
                          label: 'Name',
                          hint: 'Enter Name',
                          icon: Icons.person,
                          validator: Validators.validateName,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _staggeredController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _itemSlideIntervals[2]
                              .transform(_staggeredController.value),
                          child: child,
                        );
                      },
                      child: Form(
                        key: _formKeyEmail,
                        child: CommonTextField(
                          controller: emailController,
                          inputType: InputType.email,
                          label: 'Email',
                          hint: 'Enter Email',
                          icon: Icons.email,
                          onChanged: (String) {
                            _formKeyEmail.currentState!.validate();
                          },
                          validator: Validators.validateEmail,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _staggeredController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _itemSlideIntervals[3]
                              .transform(_staggeredController.value),
                          child: child,
                        );
                      },
                      child: Form(
                        key: _formKeyPassword,
                        child: CommonTextField(
                          controller: passwordController,
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
                    ),
                    const SizedBox(height: 30),
                    AnimatedBuilder(
                      animation: _staggeredController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _buttonInterval
                              .transform(_staggeredController.value),
                          child: child,
                        );
                      },
                      child: CustomButton(
                        onPressed: () async {
                          if (_formKeyName.currentState!.validate() &&
                              _formKeyEmail.currentState!.validate() &&
                              _formKeyPassword.currentState!.validate()) {
                            setState(() {
                              isLoading = true; // Start loading
                            });

                            try {
                              bool success = await authController.signwithemail(
                                emailController.text,
                                nameController.text,
                                passwordController.text,
                                selectedCountryCode + phoneController.text,
                                isLoading,
                              );

                              if (!success) {
                                // Handle failure (if needed)
                                Get.snackbar(
                                    "Signup Failed", "Please try again.");
                                isLoading = false;
                              }
                            } catch (e) {
                              print("Error: $e");
                              isLoading = false;
                            } finally {
                              setState(() {
                                isLoading =
                                    false; // Stop loading after completion
                              });
                            }
                          }
                        },
                        width: double.infinity,
                        text: isLoading ? 'Loading...' : 'Sign Up',
                        baseTextColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            'Login here',
                            style: TextStyle(
                              color: AppColors.logosecondry,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
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
          // Positioned.fill(
          //   child: Container(
          //     color: Colors.black
          //         .withOpacity(0.5), // Semi-transparent background
          //     child: Center(
          //       child: CircularProgressIndicator(
          //         color: AppColors.logosecondry, // Customize loading color
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
