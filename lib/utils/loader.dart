import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  final double width;
  final double height;

  const Loader({super.key, this.width = 100, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lottie/loader.json',
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }
}
