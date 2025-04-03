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
    required this.badgeCount,
    this.profileImageUrl,
  });

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  bool get hasNotifications => widget.hasNotifications;
  int get badgeCount => widget.badgeCount;
  String? get profileImageUrl => widget.profileImageUrl;

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top + 8;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFf8f8f8), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 230, 230, 230),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: topPadding, left: 16, right: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Logo and App Name
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/dlogo.svg',
                height: 40,
              ),
              const SizedBox(width: 10),
            ],
          ),

          // Right side - Menu, Notifications, Profile
          Row(
            children: [
              // Menu Icon Button
              IconButton(
                icon: const Icon(
                  Icons.grid_view_rounded,
                  color: Color(0xFF4A4A4A),
                  size: 28,
                ),
                onPressed: widget.onMenuPressed,
              ),

              // Notification Icon with Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFF4A4A4A),
                      size: 28,
                    ),
                    onPressed: widget.onNotificationPressed,
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
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

              const SizedBox(width: 8),

              // Profile Avatar Icon
              GestureDetector(
                onTap: widget.onProfilePressed,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFE0E0E0),
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : null,
                  child: profileImageUrl == null
                      ? const Icon(
                          Icons.person_outline,
                          color: Color(0xFF4A4A4A),
                          size: 24,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
