import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/utils/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _fadeText;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeText = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([fetchLocation(), _checkLoginStatus()]);
  }

  Future<void> fetchLocation() async {
    await LocationHelper.getCurrentLocation();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(milliseconds: 1500));
    User? user = FirebaseAuth.instance.currentUser;
    user != null
        ? await _getUserRole(user.uid)
        : Get.offNamed(AppRoutes.signUp);
  }

  Future<void> _getUserRole(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('difwa-users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'] ?? 'isUser';
        if (role == 'isUser') {
          Get.offNamed(AppRoutes.userbottom);
        } else if (role == 'isStoreKeeper') {
          Get.offNamed(AppRoutes.storebottombar);
        } else {
          Get.offNamed(AppRoutes.signUp);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to retrieve user role');
      Get.offNamed(AppRoutes.signUp);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              Color(0xFF141E30),
              Color(0xFF243B55)
            ], // Dark blue gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _logoScale,
                    child: SvgPicture.asset(
                      "assets/images/difwalogo.svg",
                      width: 120,
                      height: 120,
                    ),
                  ),
                  SizedBox(height: 30),
                  FadeTransition(
                    opacity: _fadeText,
                    child: Column(
                      children: [
                        Text(
                          "Welcome to Difwa",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Order Water with Ease!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20, // Keep it slightly above the bottom for spacing
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeText,
                child: Text(
                  'V1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
