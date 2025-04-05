import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/models/user_models/user_details_model.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/screens/checkout_screen.dart';
import 'package:difwa/utils/location_helper.dart';
import 'package:difwa/widgets/CustomPopup.dart';
import 'package:difwa/widgets/ImageCarouselApp.dart';
import 'package:difwa/widgets/custom_appbar.dart';
import 'package:difwa/widgets/order_details_component.dart';
import 'package:difwa/widgets/package_selector_component.dart';
import 'package:difwa/widgets/simmers/HomePageShimmer.dart';
import 'package:difwa/widgets/subscribe_button_component.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../widgets/simmers/PackageSelectorShimmer .dart';

class BookNowScreen extends StatefulWidget {
  final VoidCallback onProfilePressed;
  final VoidCallback onMenuPressed;
  const BookNowScreen(
      {super.key, required this.onProfilePressed, required this.onMenuPressed});

  @override
  _BookNowScreenState createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  Map<String, dynamic>? _selectedPackage;
  int _selectedIndex = -1;
  bool _hasEmptyBottle = false;
  int _quantity = 1;
  double _totalPrice = 0;
  bool _isLoading = true;
  List<Map<String, dynamic>> _bottleItems = [];
  String locationDetails = "Fetching location...";

  final AuthController _userData = Get.put(AuthController());
  UserDetailsModel? usersData;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    fetchBottleItems();
    fetchLocation();
  }

  void _fetchUserData() async {
    try {
      UserDetailsModel user = await _userData.fetchUserData();

      // if (mounted) {
      setState(() {
        _isLoading = false;
        usersData = user;
      });
      // }
    } catch (e) {
      // if (mounted) {
      setState(() {
        _isLoading = false;
      });
      // }
      print("Error fetching user data: $e");
    }
  }

  Future<void> fetchLocation() async {
    Position? position = await LocationHelper.getCurrentLocation();
    if (position != null) {
      Map<String, dynamic>? locationData =
          await LocationHelper.getAddressFromLatLng(position);
      if (locationData != null) {
        setState(() {
          locationDetails =
              "Address: ${locationData['address']}\n Pincode: ${locationData['pincode']}\n Lat: ${locationData['latitude']}, Lng: ${locationData['longitude']}";
        });
        print("locationDetails : $locationDetails");
      }
    } else {
      setState(() {
        locationDetails = "Location not available.";
      });
    }
  }

  /// Fetches bottle items from Firestore
  Future<void> fetchBottleItems() async {
    try {
      List<Map<String, dynamic>> fetchedItems = [];
      QuerySnapshot storeSnapshot =
          await FirebaseFirestore.instance.collection('difwa-stores').get();

      for (var storeDoc in storeSnapshot.docs) {
        QuerySnapshot itemSnapshot = await FirebaseFirestore.instance
            .collection('difwa-stores')
            .doc(storeDoc.id)
            .collection('difwa-items')
            .get();

        for (var doc in itemSnapshot.docs) {
          fetchedItems.add(doc.data() as Map<String, dynamic>);
        }
      }

      if (mounted) {
        setState(() {
          _bottleItems = fetchedItems;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load bottle data. Try again!")),
      );
    }
  }

  void _onPackageSelected(Map<String, dynamic>? package) {
    print(package);
    setState(() {
      _selectedPackage = package;
      _selectedIndex = _bottleItems.indexOf(package!);
    });

    if (package != null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       content: Text(
      //         'Selected Package: ${package['size']}L',
      //         style: TextStyle(color: Colors.white), // Ensure text is visible
      //       ),
      //       duration: const Duration(milliseconds: 2), // Set duration to 2ms
      //       backgroundColor: ThemeConstants.primaryColor // Set background color
      //       ),
      // );
      _calculateTotalPrice(); // Ensure immediate total price update
    }
  }

  /// Calculates total price based on selected package, quantity, and empty bottles
  void _calculateTotalPrice() {
    if (_selectedIndex == -1) return;

    var bottle = _bottleItems[_selectedIndex];
    double price = (bottle['price'] ?? 0) * _quantity;
    double vacantPrice = _hasEmptyBottle ? (bottle['vacantPrice'] ?? 0) : 0;

    setState(() {
      _totalPrice = price + (_quantity * vacantPrice);
    });
  }

  /// Handles subscription button press
  void _onSubscribePressed() {
    if (_selectedPackage != null && _selectedIndex != -1) {
      Get.toNamed(
        AppRoutes.subscription,
        arguments: {
          'bottle': _bottleItems[_selectedIndex],
          'quantity': _quantity,
          'price': _bottleItems[_selectedIndex]['price'],
          'vacantPrice':
              _hasEmptyBottle ? _bottleItems[_selectedIndex]['vacantPrice'] : 0,
          'hasEmptyBottle': _hasEmptyBottle,
          'totalPrice': _totalPrice,
        },
      );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomPopup(
              title: "Oops! Bottle Not Selected",
              description:
                  "Please select a bottle before moving forward. This ensures you get the best!",
              buttonText: "Got It!",
              onButtonPressed: () {
                Get.back();
              },
            );
          });
    }
  }

  /// Handles order button press
  void _onOrderPressed() {
    if (_selectedPackage != null && _selectedIndex != -1) {
      try {} catch (e) {}
      print(_bottleItems[_selectedIndex]);
      print(_bottleItems[_selectedIndex]['price']);
      print([DateTime.now()]);
      final Map<String, dynamic> myOrderData = {
        'bottle': _bottleItems[_selectedIndex],
        'quantity': _quantity,
        'price': _bottleItems[_selectedIndex]['price'],
        'vacantPrice':
            _hasEmptyBottle ? _bottleItems[_selectedIndex]['vacantPrice'] : 0,
        'hasEmptyBottle': _hasEmptyBottle,
        'totalPrice': _totalPrice,
      };
      print("Order Data: $myOrderData");
      print(
          "Total Price: ${_bottleItems[_selectedIndex]['price']} (Type: ${_bottleItems[_selectedIndex]['price'].runtimeType})");
      print("Total Days:1");
      print("Selected Dates: ${[DateTime.now()]}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            orderData: myOrderData,
            totalPrice: _totalPrice, // Ensure this is double
            totalDays: 1,
            selectedDates: [DateTime.now()],
          ),
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomPopup(
              title: "Oops! Bottle Not Selected",
              description:
                  "Please select a bottle before moving forward. This ensures you get the best!",
              buttonText: "Got It!",
              onButtonPressed: () {
                Get.back();
              },
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return _isLoading
        ? const HomePageShimmer()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: CustomAppbar(
                  onProfilePressed: widget.onProfilePressed,
                  onNotificationPressed: () {
                    Get.toNamed(AppRoutes
                        .notification); // Navigate to notifications page
                  },
                  onMenuPressed: widget.onMenuPressed,
                  hasNotifications: true,
                  badgeCount: 0, // Example badge count
                  usersData: usersData, // Profile picture URL
                )),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    // Image Carousel
                    SizedBox(
                      height: screenHeight * 0.20,
                      child: const ImageCarouselPage(),
                    ),
                    const SizedBox(height: 10),

                    // Show loading or package selector
                    _isLoading
                        ? PackageSelectorShimmer()
                        : PackageSelectorComponent(
                            bottleItems: _bottleItems,
                            onSelected: _onPackageSelected,
                          ),

                    const SizedBox(height: 16),

                    // Order details component
                    OrderDetailsComponent(
                      key: ValueKey(_selectedPackage),
                      selectedPackage: _selectedPackage,
                      onOrderUpdated: (quantity, hasEmptyBottles, totalPrice) {
                        if (_totalPrice != totalPrice) {
                          setState(() {
                            _quantity = quantity;
                            _hasEmptyBottle = hasEmptyBottles;
                            _totalPrice = totalPrice;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: SubscribeButtonComponent(
                        text: "Order Now",
                        onPressed: _onOrderPressed,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Subscribe button
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: SubscribeButtonComponent(
                        text: "Subscribe Now",
                        icon: Icons.check_circle,
                        onPressed: _onSubscribePressed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
