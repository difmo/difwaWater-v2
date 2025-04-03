import 'dart:async';
import 'package:difwa/config/app_color.dart';
import 'package:difwa/controller/admin_controller/add_items_controller.dart';
import 'package:difwa/screens/admin_screens/store_home.dart';
import 'package:difwa/screens/admin_screens/admin_orders_page.dart';
import 'package:difwa/screens/admin_screens/store_items.dart';
import 'package:difwa/screens/admin_screens/store_profile_screen.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class BottomStoreHomePage extends StatefulWidget {
  const BottomStoreHomePage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BottomStoreHomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;
  late StreamSubscription _orderSubscription;
  final FirebaseController _authController = Get.put(FirebaseController());
  final AudioPlayer _audioPlayer = AudioPlayer(); 
  String merchantIdd = "";

  late bool _isVibrating;
  late bool _isSoundPlaying;


  @override
  void initState() {
    super.initState();
    _screens = [
      const StoreHome(),
      const StoreItems(),
      AdminPanelScreen(), 
      const StoreProfileScreen(), 
    ];
    _authController.fetchMerchantId("").then((merchantId) {
      print("Fetched merchantId: $merchantId");
      setState(() {
        merchantIdd = merchantId!;
      });
      _listenForNewOrders(); 
    });

    _isVibrating = false;
    _isSoundPlaying = false;
  }

  // Listen to new orders
  void _listenForNewOrders() {
    print("Listening for new orders for merchantId: $merchantIdd");

    _orderSubscription = FirebaseFirestore.instance
        .collection('difwa-orders')
        .where('merchantId', isEqualTo: merchantIdd)
        .where('status', isEqualTo: 'paid') 
        .snapshots() // Listen to changes
        .listen((snapshot) {
      print("Snapshot received: ${snapshot.docs.length} documents found");

      if (snapshot.docs.isNotEmpty) {
        // New paid order detected, show the popup
        _showPopup(context);

        // Start vibrating and playing sound if not already
        if (!_isVibrating) {
          _startVibration();
        }
        if (!_isSoundPlaying) {
          _startSound();
        }
      } else {
        print("No paid orders found");
      }
    });
  }

  // Start continuous vibration
  void _startVibration() async {
    if (await Vibration.hasVibrator()) {
      _isVibrating = true;
      Vibration.vibrate(pattern: [500, 500], repeat: 0); // Repeat vibration
    }
  }

  // Start playing the ringtone continuously
  void _startSound() async {
    await _audioPlayer.setSource(AssetSource('audio/zomato_ring_5.mp3'));
    _audioPlayer.setReleaseMode(ReleaseMode.loop); // Make the sound loop
    _audioPlayer.play(AssetSource('audio/zomato_ring_5.mp3'));
    _isSoundPlaying = true;
  }

  // Stop the continuous vibration
  void _stopVibration() {
    Vibration.cancel();
    _isVibrating = false;
  }

  // Stop the continuous sound
  void _stopSound() async {
    _audioPlayer.stop();
    _isSoundPlaying = false;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Update the order status in Firestore
  void _updateOrderStatus(String status) {
    // You would need to get the document reference of the order you want to update
    FirebaseFirestore.instance
        .collection('difwa-orders')
        .where('merchantId', isEqualTo: merchantIdd)
        .where('status',
            isEqualTo:
                'paid') // Filter based on your conditions (e.g., 'paid' status)
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
    if (_isVibrating) _stopVibration();
    if (_isSoundPlaying) _stopSound();
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

  // Show the popup with two buttons
  // Show the popup with two buttons
  // Show the popup with two buttons
  // Show the popup with two buttons
void _showPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return SafeArea(
        child: GestureDetector(
          onTap: () {
            // Prevent the dialog from closing when tapping inside
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blueAccent, // Background color for the popup
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delivery_dining,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  'New Order Incoming!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Do you want to confirm or cancel?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cancel button
                    TextButton(
                      onPressed: () {
                        _stopVibration();
                        _stopSound();
                        _updateOrderStatus('canceled');
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    // Confirm button
                    TextButton(
                      onPressed: () {
                        _stopVibration();
                        _stopSound();
                        _updateOrderStatus('confirmed');
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}




}
