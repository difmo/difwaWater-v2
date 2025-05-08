import 'package:difwa/config/app_color.dart';
import 'package:difwa/controller/OnboardingController.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/utils/app__text_style.dart';
import 'package:difwa/widgets/others/back_press_toexit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserOnboardingScreen extends StatefulWidget {
  const UserOnboardingScreen({super.key});

  @override
  State<UserOnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<UserOnboardingScreen> {
  final OnboardingController controller = Get.put(OnboardingController());

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/onboardingimg/welcome.svg',
      'title': 'Welcome to Difwa',
      'description':
          'Get water delivered to your home with just a few taps. Reliable service, always on time, anytime you need it.',
    },
    {
      'image': 'assets/onboardingimg/waterformet.svg',
      'title': 'From Source to Sip',
      'description':
          'We partner with trusted sources to bring you the cleanest water. Every drop is filtered and certified for safety.',
    },
    {
      'image': 'assets/onboardingimg/onboarding2.svg',
      'title': 'Hydrate. Simplified.',
      'description':
          'Thousands trust Difwa to stay hydrated. Join the community and make water delivery effortless and efficient.',
    },
  ];

  @override
  void initState() {
    super.initState();
    // _checkOnboardingStatus();
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    Get.offAllNamed(AppRoutes.login); // navigate to signup
  }

  @override
  Widget build(BuildContext context) {
    return BackPressToExit(
      child: Scaffold(
        body: Stack(
          children: [
            _buildPageView(),
            _buildIndicator(),
            _buildBackgroundCircle(),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    if (controller.currentIndex < 2) {
      controller.nextPage();
    } else {
      _markOnboardingComplete();
      Get.toNamed(AppRoutes.login);
    }
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: controller.pageController,
      onPageChanged: (index) => controller.currentIndex.value = index,
      itemCount: onboardingData.length,
      itemBuilder: (context, index) {
        return OnboardingPage(
          image: onboardingData[index]['image']!,
          title: onboardingData[index]['title']!,
          description: onboardingData[index]['description']!,
        );
      },
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 220,
      child: Align(
        alignment: Alignment.center,
        child: Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 50.0,
                height: 8.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: controller.currentIndex.value == index
                      ? AppColors.buttonbgColor
                      : AppColors.darkGrey,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBackgroundCircle() {
    return Positioned(
      left: -400,
      right: -400,
      bottom: -500,
      child: Center(
        child: Container(
          width: 800,
          height: 700,
          decoration: BoxDecoration(
            color: AppColors.cardbgcolor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 50,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: double.infinity,
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _markOnboardingComplete,
                  child: Text("Skip", style: AppTextStyle.Text18300LogoColor),
                ),
                Obx(() {
                  return controller.currentIndex.value !=
                          onboardingData.length - 1
                      ? TextButton(
                          onPressed: _onNext,
                          child: Text("Next",
                              style: AppTextStyle.Text18300LogoColor),
                        )
                      : TextButton(
                          onPressed: _markOnboardingComplete,
                          child: Text("Get Started",
                              style: AppTextStyle.Text18300LogoColor),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              image,
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 150,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    style: AppTextStyle.Text18300LogoColor.copyWith(
                        fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    description,
                    style: AppTextStyle.Text18300LogoColor.copyWith(
                        fontSize: 18, color: AppColors.buttontextcolor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
