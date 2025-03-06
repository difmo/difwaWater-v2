import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;

  const Loader({
    super.key,
    this.width = 100,
    this.height = 100,
    this.backgroundColor = const Color(0x80000000), // Default semi-transparent black background
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: backgroundColor, // Set the background color here
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Optional padding around the loader
          child: Lottie.asset(
            'assets/lottie/loader.json',
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
