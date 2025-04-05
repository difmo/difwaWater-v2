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
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  String locationDetails = "Fetching location...";

  @override
  void initState() {
    super.initState();
    fetchLocation();
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

  Future<void> fetchLocation() async {
    Position? position = await LocationHelper.getCurrentLocation();
    if (position != null) {
      Map<String, dynamic>? locationData =
          await LocationHelper.getAddressFromLatLng(position);
      if (locationData != null) {
        setState(() {
          locationDetails =
              "📍 Address: ${locationData['address']}\n📌 Pincode: ${locationData['pincode']}\n🌍 Lat: ${locationData['latitude']}, Lng: ${locationData['longitude']}";
        });
        print("locationDetails : $locationDetails");
      }
    } else {
      setState(() {
        locationDetails = "Location not available.";
      });
    }
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
      } else {
        Get.offNamed(AppRoutes.signUp);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to retrieve user role');
      Get.offNamed(AppRoutes.signUp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF010614),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Distributes widgets evenly
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 300.0),
                  child: FadeTransition(
                    opacity: _logoOpacity,
                    child: SvgPicture.asset(
                      "assets/images/difwalogo.svg",
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _textOpacity,
                      child: Text(
                        "Welcome to Difwa",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeTransition(
                      opacity: _textOpacity,
                      child: Text(
                        'Hassle-Free Water Delivery \nat Your Fingertips!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),

            // ),
            // const SizedBox(height: 150),

            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: FadeTransition(
                opacity: _textOpacity,
                child: const Text(
                  'Powered by Difmo',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
