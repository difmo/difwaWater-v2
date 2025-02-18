import 'package:difwa/config/app_color.dart';
import 'package:flutter/material.dart';

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
  bool get hasNotifications => widget.hasNotifications;
  String? get profileImageUrl => widget.profileImageUrl;

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
      padding: EdgeInsets.only(top: topPadding, left: 16, right: 16, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Water Drop Icon and Text
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.myblack, // Black background
                  shape: BoxShape.circle, // Circular shape
                ),
                padding: EdgeInsets.all(4), // Adjust padding to fit the icon
                child: const Icon(
                  Icons.water_drop,
                  color: Colors.white,
                  size: 25, // Adjust the icon size
                ),
              ),
              SizedBox(width: 4),
              const Text(
                'FreshDropHydrate',
                style: TextStyle(
                  color: AppColors.myblack,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
            ],
          ),
          // Right side - Notification, Menu, Profile
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.circle_notifications,
                      color: hasNotifications ? AppColors.myblack : Colors.black,
                      size: 30,
                    ),
                    onPressed: widget.onNotificationPressed,
                  ),
                  if (hasNotifications)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                ],
              ),
              // IconButton(
              //   icon: const Icon(Icons.grid_view),
              //   onPressed: widget.onMenuPressed,
              // ),
              // IconButton(
              //   icon: const Icon(Icons.person),
              //   onPressed: widget.onProfilePressed,
              // ),
              if (profileImageUrl != null)
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(profileImageUrl!),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
