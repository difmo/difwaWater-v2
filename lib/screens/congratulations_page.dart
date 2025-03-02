import 'package:difwa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CongratulationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(AppRoutes
            .userbottom); // This will navigate to home and remove all previous routes
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Congratulations')),
        body: const Center(
          child: Text(
            'Your payment was successful!\nThank you for your order.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
