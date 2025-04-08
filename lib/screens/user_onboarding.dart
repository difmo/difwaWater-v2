import 'package:difwa/config/app_color.dart';
import 'package:difwa/config/app_styles.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserOnboardingScreen extends StatefulWidget {
  const UserOnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<UserOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  // Check if the onboarding is completed
  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnboardingComplete = prefs.getBool('onboardingComplete') ?? false;

    if (isOnboardingComplete) {
      // If onboarding is already complete, skip to the home page
      Get.offNamed(AppRoutes
          .home); // Using `Get.offNamed` to replace this screen in the navigation stack
    }
  }

  // Mark onboarding as complete in SharedPreferences
  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
  }

  List<Widget> _buildPageIndicator() {
    return List.generate(
      3,
      (index) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: 10.0,
        width: _currentIndex == index ? 20.0 : 10.0,
        decoration: BoxDecoration(
          color: _currentIndex == index ? AppColors.primary : Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void _onNext() {
    if (_currentIndex < 2) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      _markOnboardingComplete(); // Mark onboarding as completed
      Get.toNamed(AppRoutes.home); // Navigate to the home screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              _buildOnboardingPage(
                middleImage: 'assets/onboardingimg/welcome.svg',
                newHeading: 'Streamlined Order Management',
                newDescription:
                    'Welcome to Difwa! Simplify your water delivery business today.',
                titleColor: Colors.white,
                showButton: false,
                onNextPressed: _onNext,
              ),
              _buildOnboardingPage(
                middleImage: 'assets/onboardingimg/waterformet.svg',
                newHeading: 'Farm to Table!',
                newDescription: 'Experience the freshness of local produce.',
                titleColor: Colors.black,
                showButton: false,
                onNextPressed: _onNext,
              ),
              _buildOnboardingPage(
                middleImage: 'assets/onboardingimg/onboarding2.svg',
                newHeading: 'Join Our Community!',
                newDescription:
                    'Connect with fellow food lovers and share recipes.',
                titleColor: Colors.white,
                showButton: true,
                onNextPressed: _onNext,
              ),
            ],
          ),
          Positioned(
            bottom: 30.0,
            left: 20.0,
            right: 20.0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            ),
          ),
          // Bottom Left Button
          Positioned(
            bottom: 20,
            left: 25,
            child: TextButton(
              onPressed: () {
                Get.toNamed(AppRoutes.signUp);
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: AppColors.myblack,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // Bottom Right Button
          Positioned(
            bottom: 20,
            right: 25,
            child: Visibility(
              visible: _currentIndex != 2, // Hide "Next" on the last page
              child: TextButton(
                onPressed: () {
                  if (_currentIndex < 2) {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  } else {
                    _markOnboardingComplete(); // Mark onboarding as complete
                    Get.toNamed(AppRoutes.userbottom);
                  }
                },
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: const Color.fromARGB(179, 45, 45, 45),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String middleImage,
    required String newHeading,
    required String newDescription,
    required Color titleColor,
    required bool showButton,
    VoidCallback? onNextPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                SvgPicture.asset(
                  middleImage,
                  width:
                      300, // Adjust this value to make the image larger or smaller
                  height:
                      300, // Adjust this value to make the image larger or smaller
                ),
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(newHeading, style: AppStyle.heading1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(newDescription,
                      textAlign: TextAlign.center, style: AppStyle.greyText18),
                ),
                const SizedBox(height: 30),
                if (showButton)
                  CustomButton(
                    text: "Welcome",
                    onPressed: () {
                      _markOnboardingComplete(); // Mark onboarding as completed
                      Get.toNamed(
                          AppRoutes.signUp); // Navigate to the next screen
                    },
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
