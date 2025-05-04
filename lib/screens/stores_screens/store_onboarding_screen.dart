import 'package:difwa/config/app_color.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/utils/app__text_style.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StoreOnboardingScreen extends StatefulWidget {
  const StoreOnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<StoreOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  List<Widget> _buildPageIndicator() {
    return List.generate(
      4, // Number of pages
      (index) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: 10.0,
        width: _currentIndex == index ? 20.0 : 10.0,
        decoration: BoxDecoration(
          color: _currentIndex == index
              ? ThemeConstants.primaryColor
              : Colors.grey,
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
      Get.toNamed(AppRoutes.vendoform);
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
                middleImage: 'assets/onboardingimg/onboarding0.svg',
                newHeading: 'Streamlined Order Management',
                newDescription:
                    'Easily track, process, and manage customer orders in real-time. No more missed deliveries or errors—stay on top of your business effortlessly.',
                titleColor: Colors.white,
                showButton: false,
              ),
              _buildOnboardingPage(
                middleImage: 'assets/onboardingimg/onboarding1.svg',
                newHeading: 'Streamlined Order Management',
                newDescription:
                    'Easily track, process, and manage customer orders in real-time. No more missed deliveries or errors—stay on top of your business effortlessly.',
                titleColor: Colors.white,
                showButton: false,
              ),
              _buildOnboardingPage(
                middleImage: 'assets/onboardingimg/onboarding2.svg',
                newHeading: 'Farm to Table!',
                newDescription:
                    'Easily track, process, and manage customer orders in real-time. No more missed deliveries or errors—stay on top of your business effortlessly.',
                titleColor: Colors.black,
                showButton: false,
              ),
              _buildOnboardingPage(
                middleImage: 'assets/onboardingimg/onboarding3.svg',
                newHeading: 'Join Our Community!',
                newDescription:
                    'Connect with fellow food lovers and share recipes.',
                titleColor: Colors.white,
                showButton: true, // Show button on the last page
                onNextPressed: _onNext, // Pass the callback
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
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String middleImage,
    required String newHeading,
    required String newDescription,
    required Color titleColor,
    required bool showButton, // New parameter for showing button
    VoidCallback? onNextPressed, // Callback for button press
  }) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Stack(
        children: [
          // Background image

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    middleImage,
                  ),
                ),
                const SizedBox(height: 130),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(newHeading,
                      style: AppTextStyle.Text18700.copyWith(
                          color: ThemeConstants.primaryColor)),
                ),
                // New Description below the new heading
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(newDescription,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.Text14400),
                ),
                const SizedBox(height: 30),
                // Button on the last page
                if (showButton)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppColors.logoprimary),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      onPressed: onNextPressed,
                      child: const Text(
                        "Create Store",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
