import 'dart:async';

import 'package:difwa/config/app_color.dart';
import 'package:difwa/screens/admin_screens/store_home.dart';
import 'package:difwa/screens/admin_screens/admin_orders_page.dart';
import 'package:difwa/screens/admin_screens/store_items.dart';
import 'package:difwa/screens/admin_screens/store_profile_screen.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class BottomStoreHomePage extends StatefulWidget {
  const BottomStoreHomePage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BottomStoreHomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;
  late StreamSubscription _orderSubscription;

  @override
  void initState() {
    super.initState();
    _screens = [
      const StoreHome(),
      const StoreItems(),
      AdminPanelScreen(), // Orders Screen
      const StoreProfileScreen(), // Profile Screen
    ];

    _listenForNewOrders();

    Future.delayed(Duration(seconds: 5), () {
      _showPopup(context); // Show the popup after 5 seconds
    });
  }

  // Listen to new orders
  void _listenForNewOrders() {
    FirebaseFirestore.instance
        .collection('difwa-orders') // Assuming orders collection
        .where('status', isEqualTo: 'paid') // You can modify this condition as per your data
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // A new order has been added
        _showPopup(context); // Show the popup for new order
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Show the popup with two buttons
  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Order'),
          content: Text('You have a new order. Do you want to confirm or cancel?'),
          actions: [
            TextButton(
              onPressed: () {
                // Cancel button pressed
                _showCancelConfirmationDialog(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Confirm button pressed
                _updateOrderStatus('confirmed'); // Update order status to confirmed
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Show the confirmation dialog when the cancel button is clicked
  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you really want to cancel this order?'),
          actions: [
            TextButton(
              onPressed: () {
                // Cancel action - Close the confirmation dialog
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Confirm cancel action
                _updateOrderStatus('canceled'); // Update order status to canceled
                Navigator.of(context).pop(); // Close the confirmation dialog
                Navigator.of(context).pop(); // Close the initial popup
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // Update the order status in Firestore
  void _updateOrderStatus(String status) {
    // You would need to get the document reference of the order you want to update
    FirebaseFirestore.instance
        .collection('difwa-orders')
        .where('status', isEqualTo: 'paid') // Filter based on your conditions (e.g., 'paid' status)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Assuming we're updating the first order found (modify as necessary)
        var orderDoc = snapshot.docs.first;
        orderDoc.reference.update({'status': status}).then((_) {
          // Successfully updated the order status
          print('Order status updated to $status');
        }).catchError((error) {
          print('Failed to update order status: $error');
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _orderSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.whiteColor,
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.only(top: 5.0),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: AppColors.inputfield, // Shadow color from AppColors
              blurRadius: 3.0,
              spreadRadius: 0.5,
              offset: Offset(0, 4), // Direction of the shadow
            ),
          ],
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(0), // No rounded corners on the top
            bottom: Radius.circular(8), // Bottom corner radius
          ),
        ),
        child: BottomNavigationBar(
          selectedLabelStyle: TextStyle(color: Colors.blue),
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _buildSvgIcon(
                  'assets/icons/home.svg', 'assets/icons/home_filled.svg', 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildSvgIcon(
                  'assets/icons/order.svg', 'assets/icons/order_filled.svg', 1),
              label: 'Bottles',
            ),
            BottomNavigationBarItem(
              icon: _buildSvgIcon('assets/icons/wallet.svg',
                  'assets/icons/wallet_filled.svg', 2),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: _buildSvgIcon('assets/icons/profile.svg',
                  'assets/icons/profile_filled.svg', 3),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.inputfield, // Color when selected
        ),
      ),
    );
  }

  // Custom method to build the icon with zoom effect and SVG background
  Widget _buildSvgIcon(String unselectedPath, String selectedPath, int index) {
    bool isSelected = _selectedIndex == index;

    return SvgPicture.asset(
      isSelected ? selectedPath : unselectedPath,
      width: isSelected ? 30 : 24, // Slightly larger when selected
      height: isSelected ? 30 : 24,
      colorFilter: ColorFilter.mode(
        isSelected
            ? AppColors.inputfield
            : Colors.black, // Change color dynamically
        BlendMode.srcIn,
      ),
    );
  }
}
