import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    Timer(const Duration(seconds: 3), _checkLoginStatus);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _getUserRole(user.uid);
    } else {
      Get.offNamed(AppRoutes.signUp);
    }
  }

  Future<void> _getUserRole(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('difwa-users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'] ?? 'isUser';
        print("User role: $role");
        if (role == 'isUser') {
          Get.offNamed(AppRoutes.userbottom);
        } else if (role == 'isStoreKeeper') {
          Get.offNamed(AppRoutes.storebottombar);
        } else {
          Get.offNamed(AppRoutes.signUp);
        }
      }
      // else {
      //   Get.offNamed(AppRoutes.login);
      // }
    } catch (e) {
      Get.snackbar('Error', 'Failed to retrieve user role');
      Get.offNamed(AppRoutes.signUp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF010614),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FadeTransition(
                  opacity: _logoOpacity,
                  child: SvgPicture.asset(
                    "assets/images/difwalogo.svg",
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            child: Center(
              child: SvgPicture.asset(
                "assets/elements/splash.svg",
              ),
            ),
          ),

          // Text with fade-in animation
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textOpacity,
              child: const Center(
                child: Text(
                  'Powered by Difmo',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
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
