import 'dart:ui';

import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/screens/admin_screens/store_onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../config/app_color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // final authController = Get.find<AuthController>(); // Example if using GetX

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mywhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pritam',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '+91 7800730968',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const MenuOption(
              icon: Icons.home,
              title: 'Addresses',
            ),
            const MenuOption(
              icon: Icons.group_add,
              title: 'Invite Friends',
            ),
            const MenuOption(
              icon: Icons.help,
              title: 'Help Center',
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StoreOnboardingScreen(),
                  ),
                );
              },
              child: const MenuOption(
                icon: Icons.store,
                title: 'Become A Seller',
              ),
            ),
            const MenuOption(
              icon: Icons.info_outline,
              title: 'About Us',
            ),
            const MenuOption(
              icon: Icons.info_outline,
              title: 'About Us',
            ),
            const MenuOption(
              icon: Icons.contact_mail,
              title: 'Contact Us',
            ),
            GestureDetector(
              onTap: () async {
                try {
                  await _auth.signOut();
                  Get.snackbar('Success', 'Logged out successfully');
                  Get.offAllNamed(AppRoutes.login);
                } catch (e) {
                  Get.snackbar('Error', 'Error logging out: $e');
                }
              },
              child: const MenuOption(
                icon: Icons.store,
                title: 'Logout',
              ),
            ),
            const MenuOption(
              icon: Icons.contact_mail,
              title: 'Become a dealer',
            ),
          ],
        ),
      ),
    );
  }
}

class MenuOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuOption({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.primary),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward, size: 24, color:AppColors.primary),
        ],
      ),
    );
  }
}
