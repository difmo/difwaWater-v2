import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), _checkLoginStatus);
  }

  Future<void> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    print('FDHGNS :$user');
    // Get.offNamed(AppRoutes.userbottom);

    if (user != null) {
      await _getUserRole(user.uid);
    } else {
      // Get.offNamed(AppRoutes.loginwithmobilenumber);
      Get.offNamed(AppRoutes.login);
      // Get.offNamed(AppRoutes.userbottom);
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

        if (role == 'isUser') {
          Get.offNamed(AppRoutes.userbottom);
        } else if (role == 'isStoreKeeper') {
          Get.offNamed(AppRoutes.storebottombar);
        } else {
          Get.offNamed(AppRoutes.login);
        }
      } else {
        Get.offNamed(AppRoutes.login);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to retrieve user role');
      Get.offNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/logos/logo.svg",
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
