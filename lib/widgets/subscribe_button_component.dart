import 'package:difwa/utils/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscribeButtonComponent extends StatelessWidget {
  final VoidCallback onPressed;

  const SubscribeButtonComponent({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: const BoxDecoration(
            color: ThemeConstants.blackColor,
            borderRadius: BorderRadius.all(Radius.circular(2))),
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: const Text(
            'Subscribe Now',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
