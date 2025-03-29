import 'package:difwa/config/app_color.dart';
import 'package:difwa/config/app_textstyle.dart';
import 'package:difwa/screens/admin_screens/store_home.dart';
import 'package:difwa/screens/admin_screens/admin_orders_page.dart';
import 'package:difwa/screens/admin_screens/store_items.dart';
import 'package:difwa/screens/admin_screens/store_profile_screen.dart';
import 'package:flutter/material.dart';

class BottomStoreHomePage extends StatefulWidget {
  const BottomStoreHomePage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BottomStoreHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const StoreHome(),
    const StoreItems(),
    const AdminPanelScreen(),
    const StoreProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index >= 0 && index < _screens.length) { // Ensure index is within bounds
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(
          bottom: 0,
        ),
        padding: const EdgeInsets.only(top: 5.0),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.home, 0),
                label: '',  // Removed label
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.store, 1),
                label: '',  // Removed label
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.shopping_bag, 2),
                label: '',  // Removed label
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.person_2_rounded, 3),
                label: '',  // Removed label
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.darkGrey,
            selectedLabelStyle: AppTTextStyle.selectedTabStyle,
            unselectedLabelStyle: AppTTextStyle.unSelectedTabStyle,
          ),
        ),
      ),
    );
  }

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
          if (isSelected)
            Image.asset(
              'assets/icons/iconbg.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          Icon(
            iconData,
            size: isSelected ? 30 : 18,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }
}
