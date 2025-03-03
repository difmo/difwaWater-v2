import 'package:difwa/config/app_color.dart';
import 'package:difwa/screens/book_now_screen.dart';
import 'package:difwa/screens/ordershistory_screen.dart';
import 'package:difwa/screens/profile_screen.dart';
import 'package:difwa/screens/user_wallet_page.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Import flutter_svg package

class BottomUserHomePage extends StatefulWidget {
  const BottomUserHomePage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BottomUserHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const BookNowScreen(),
    const WalletScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.whiteColor,
      body: _screens[_selectedIndex], // Display the screen based on selected index
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.only(top: 5.0),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: AppColors.inputfield, // Assuming AppColors.inputfield is a Color
              blurRadius: 3.0, // Adjust blur radius as needed
              spreadRadius: 0.5, // Adjust spread radius if needed
              offset: Offset(0, 4), // Adjust the offset for shadow direction
            ),
          ],
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(0), // No rounded corners on the top
            bottom: Radius.circular(8), // Optional: Adjust bottom corners' radius
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.home, 0),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.shopping_bag_rounded, 1),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.shopping_cart_rounded, 2),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.person, 3),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.inputfield, // Color when selected
          unselectedItemColor: Colors.white, // Color when not selected
        ),
      ),
    );
  }

  // Custom method to build the icon with zoom effect and SVG background
  Widget _buildIcon(IconData iconData, int index) {
    bool isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(isSelected ? 10 : 9), // Add padding for zoom effect
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Round corners for background
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background SVG image when selected
          if (isSelected)
            SvgPicture.asset(
              'assets/icons/iconbg.svg', // Replace with your actual SVG asset path
              width: 60, // Adjust size as per your requirement
              height: 60, // Adjust size as per your requirement
            ),
          // Icon on top of the SVG background
          Icon(
            iconData,
            size: isSelected ? 30 : 20, // Zoom in when selected
            color: isSelected ? Colors.white : Colors.black, // Change icon color when selected
          ),
        ],
      ),
    );
  }
}
