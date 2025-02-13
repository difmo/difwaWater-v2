import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CustomAppbar extends StatefulWidget {
  final VoidCallback onProfilePressed;
  final VoidCallback onNotificationPressed;
  final VoidCallback onMenuPressed;
  final bool hasNotifications;
  final String? profileImageUrl;

  const CustomAppbar({
    super.key,
    required this.onProfilePressed,
    required this.onNotificationPressed,
    required this.onMenuPressed,
    required this.hasNotifications,
    this.profileImageUrl,
  });

  @override
  _CustomToolbarState createState() => _CustomToolbarState();
}

class _CustomToolbarState extends State<CustomAppbar> {
  // No need for 'late' here
  bool get hasNotifications => widget.hasNotifications;  // Directly using the widget's property
  String? get profileImageUrl => widget.profileImageUrl;  // Directly using the widget's property

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top + 16;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color.fromARGB(255, 255, 255, 255)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 244, 244, 244),
            width: 1.0,
          ),
        ),
      ),
      padding: EdgeInsets.only(top: topPadding, left: 16, right: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: SvgPicture.asset(
                  'assets/images/difwalogo.svg',
                  width: 109,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          Row(
            children: [
              
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: widget.onNotificationPressed,
                  ),
               
                ],
              ),
              // IconButton(
              //   icon: const Icon(Icons.grid_view),
              //   onPressed: widget.onMenuPressed,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
