import 'package:difwa/config/app_color.dart';
import 'package:difwa/config/app_styles.dart';
import 'package:difwa/screens/admin_screens/store_home.dart';
import 'package:difwa/screens/admin_screens/admin_orders_page.dart';
import 'package:difwa/screens/admin_screens/store_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Import flutter_svg package

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
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.darkGrey,
            selectedLabelStyle: AppStyle.selectedTabStyle,
            unselectedLabelStyle: AppStyle.unSelectedTabStyle,
          ),
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
            Image.asset(
            'assets/icons/iconbg.png', // Replace with your actual PNG asset path
            width: 50, // Adjust size as per your requirement
            height: 50, // Adjust size as per your requirement
            fit: BoxFit.cover, // Optional: Use this to make sure the image fits the container
          ),
          // Icon on top of the SVG background
          Icon(
            iconData,
            size: isSelected ? 30 : 18, // Zoom in when selected
            color: isSelected ? Colors.white : Colors.black, // Change icon color when selected
          ),
        ],
      ),
    );
  }
}
