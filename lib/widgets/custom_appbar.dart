import 'package:difwa/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppbar extends StatefulWidget {
  final VoidCallback onProfilePressed;
  final VoidCallback onNotificationPressed;
  final VoidCallback onMenuPressed;
  final bool hasNotifications;
  final int badgeCount; // Badge count for notifications
  final String? profileImageUrl;

  const CustomAppbar({
    super.key,
    required this.onProfilePressed,
    required this.onNotificationPressed,
    required this.onMenuPressed,
    required this.hasNotifications,
    required this.badgeCount, // Pass badge count
    this.profileImageUrl,
  });

  @override
  _CustomToolbarState createState() => _CustomToolbarState();
}

class _CustomToolbarState extends State<CustomAppbar> {
  bool get hasNotifications => widget.hasNotifications;
  int get badgeCount => widget.badgeCount;
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
                child: SvgPicture.asset(
                  'assets/images/dlogo.svg', // Your logo image path
                ),
              ),
            ],
          ),
          // Right side - Notification, Menu, Profile
          Row(
            children: [
              // Notification Icon with Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: AppColors.logoprimary,
                      size: 30,
                    ),
                    onPressed: widget.onNotificationPressed,
                  ),
                  if (badgeCount >= 0)
                    Positioned(
                      right: 10,
                      top: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 15,
                          minHeight: 5,
                        ),
                        child: Text(
                          '$badgeCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}












   // IconButton(
              //   icon: const Icon(Icons.grid_view),
              //   onPressed: widget.onMenuPressed,
              // ),
              // IconButton(
              //   icon: const Icon(Icons.person),
              //   onPressed: widget.onProfilePressed,
              // ),
              // if (profileImageUrl != null)
              //   CircleAvatar(
              //     radius: 16,
              //     backgroundImage: NetworkImage(profileImageUrl!),
              //   ),