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

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnboardingComplete = prefs.getBool('onboardingComplete') ?? false;
    if (isOnboardingComplete) {
      Get.offNamed(AppRoutes.home);
    }
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
  }

  void _onNext() {
    if (_currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _markOnboardingComplete();
    }
  }

  List<Widget> _buildPageIndicator() {
    return List.generate(
      3,
      (index) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 10,
        width: _currentIndex == index ? 24 : 12,
        decoration: BoxDecoration(
          color:
              _currentIndex == index ? AppColors.logoprimary : Colors.grey[400],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: Colors.white
              // gradient: LinearGradient(
              //   colors: [Color(0xFFe0f7fa), Color(0xFFffffff)],
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              // ),
              ),
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: [
                  _buildOnboardingPage(
                    image: 'assets/onboardingimg/welcome.svg',
                    title: 'Welcome to Difwa',
                    subtitle:
                        'Get water delivered to your home with just a few taps. Reliable service, always on time, anytime you need it.',
                    textColor: AppColors.logoprimary,
                    showCTA: false,
                  ),
                  _buildOnboardingPage(
                    image: 'assets/onboardingimg/waterformet.svg',
                    title: 'From Source to Sip',
                    subtitle:
                        'We partner with trusted sources to bring you the cleanest water. Every drop is filtered and certified for safety.',
                    textColor: AppColors.logoprimary,
                    showCTA: false,
                  ),
                  _buildOnboardingPage(
                    image: 'assets/onboardingimg/onboarding2.svg',
                    title: 'Hydrate. Simplified.',
                    subtitle:
                        'Thousands trust Difwa to stay hydrated. Join the community and make water delivery effortless and efficient.',
                    textColor: AppColors.logoprimary,
                    showCTA: true,
                  ),
                ],
              ),
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    color: AppColors.logoprimary.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Positioned(
                          bottom: 40,
                          left: 20,
                          child: TextButton(
                            onPressed: () {
                              _markOnboardingComplete();
                              Get.toNamed(AppRoutes.signUp);
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 40,
                          right: 20,
                          child: _currentIndex != 2
                              ? Container(
                                  padding: EdgeInsets.only(left: 8),
                                  child: TextButton(
                                    onPressed: _onNext,
                                    child: Text(
                                      "Next",
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: TextButton(
                                    onPressed: () {
                                      _markOnboardingComplete();
                                      Get.toNamed(AppRoutes.signUp);
                                    },
                                    child: Text(
                                      "Finish",
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String image,
    required String title,
    required String subtitle,
    required Color textColor,
    required bool showCTA,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          SvgPicture.asset(
            image,
            height: 260,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 50),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyle.headingBlack.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade800,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 40),
          if (showCTA)
            CustomButton(
              onPressed: () async {
                _markOnboardingComplete();
                Get.toNamed(AppRoutes.signUp);
              },
              height: 54,
              width: double.infinity,
              text: 'Get Started',
              baseTextColor: Colors.white,
            ),
        ],
      ),
    );
  }
}
