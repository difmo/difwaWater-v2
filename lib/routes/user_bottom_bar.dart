import 'package:difwa/config/app_color.dart';
import 'package:difwa/screens/book_now_screen.dart';
import 'package:difwa/screens/ordershistory_screen.dart';
import 'package:difwa/screens/profile_screen.dart';
import 'package:difwa/screens/user_wallet_page.dart';
import 'package:difwa/test.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomUserHomePage extends StatefulWidget {
  const BottomUserHomePage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BottomUserHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const BookNowScreen(),
    const HistoryScreen(),
    const WalletScreen(),
    ProfileScreen(),
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
      body: _screens[
          _selectedIndex], // Display the screen based on selected index
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.only(top: 5.0),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: AppColors
                  .inputfield, // Assuming AppColors.inputfield is a Color
              blurRadius: 3.0, // Adjust blur radius as needed
              spreadRadius: 0.5, // Adjust spread radius if needed
              offset: Offset(0, 4), // Adjust the offset for shadow direction
            ),
          ],
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(0), // No rounded corners on the top
            bottom:
                Radius.circular(8), // Optional: Adjust bottom corners' radius
          ),
        ),
        child: BottomNavigationBar(
          selectedLabelStyle: TextStyle(color: Colors.blue),
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
             BottomNavigationBarItem(
              icon: _buildSvgIcon('assets/icons/home.svg','assets/icons/home_filled.svg' , 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildSvgIcon('assets/icons/order.svg','assets/icons/order_filled.svg', 1),
              label: 'My Orders',
            ),
            BottomNavigationBarItem(
              icon: _buildSvgIcon('assets/icons/wallet.svg', 'assets/icons/wallet_filled.svg', 2),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: _buildSvgIcon('assets/icons/profile.svg','assets/icons/profile_filled.svg',  3),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.inputfield, // Color when selected
          // unselectedItemColor: Colors.black, // Color when not selected
        ),
      ),
    );
  }

  // Custom method to build the icon with zoom effect and SVG background
  Widget _buildSvgIcon(String unselectedPath, String selectedPath,  int index) {
    bool isSelected = _selectedIndex == index;

    return SvgPicture.asset(
       isSelected ? selectedPath : unselectedPath,
      width: isSelected ? 30 : 24, // Slightly larger when selected
      height: isSelected ? 30 : 24,
      colorFilter: ColorFilter.mode(
        isSelected ? AppColors.inputfield : Colors.black, // Change color dynamically
        BlendMode.srcIn,
      ),
    );
  }
}
