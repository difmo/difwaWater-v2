import 'dart:ui';

import 'package:difwa/controller/bottle_controller.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookNowScreen extends StatefulWidget {
  const BookNowScreen({super.key});

  @override
  _BookNowScreenState createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  int _selectedIndex = -1;
  bool _hasEmptyBottle = false;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final BottleController bottleController = Get.put(BottleController());

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppbar(onProfilePressed: (){}, onNotificationPressed: (){}, onMenuPressed: (){}, hasNotifications: true)
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(() {
                if (bottleController.bottleItems.isEmpty) {
                  return const CircularProgressIndicator(); 
                }

                return SizedBox(
                  height: 200, // Card height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bottleController.bottleItems.length,
                    itemBuilder: (context, index) {
                      var bottle = bottleController.bottleItems[index];
                      bool isSelected = index == _selectedIndex;

                      String imagePath;
                      switch (bottle['size']) {
                        case 15:
                          imagePath =
                              'assets/images/water.jpg'; 
                          break;
                        case 20:
                          imagePath =
                              'assets/images/water.jpg'; 
                          break;
                        case 10:
                          imagePath =
                              'assets/images/water.jpg'; 
                          break;
                        default:
                          imagePath =
                              'assets/images/water.jpg';                         break;
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = isSelected ? -1 : index;
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 4,
                          color: isSelected
                              ? Colors.amber
                              : Colors.white, // Highlight selected card
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  imagePath, // Use the conditional image path
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${bottle['size']}L',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '₹ ${bottle['price']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 16),
              // Select number of bottles and total price section
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Choose the number of bottles you would like to buy.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_quantity > 1) _quantity--;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down, size: 32),
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _quantity++; // Increase bottle count
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_up, size: 32),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _hasEmptyBottle, // Bind the checkbox state
                            onChanged: (value) {
                              setState(() {
                                _hasEmptyBottle = value ??
                                    false; // Update state when checkbox is toggled
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              "I don't have empty bottles to return",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_selectedIndex != -1) // Show selected bottle details
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Water Price:'),
                                Text(
                                  '₹ ${bottleController.bottleItems[_selectedIndex]['price']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Bottle Price:'),
                                Text(
                                  _hasEmptyBottle
                                      ? '₹ ${bottleController.bottleItems[_selectedIndex]['vacantPrice']}' // If checkbox is checked, add bottle price
                                      : '₹ 0', // If not checked, no bottle price
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Price:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                                Text(
                                  '₹ ${(_quantity * bottleController.bottleItems[_selectedIndex]['price']) + (_hasEmptyBottle ? (_quantity * bottleController.bottleItems[_selectedIndex]['vacantPrice']) : 0)}', // Corrected calculation
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // One-Time Order Button
                  ElevatedButton(
                    onPressed: () {
                      // Handle one-time order action
                      print("One-time order placed");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                    ),
                    child: const Text(
                      "Order Now",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Ensure data is available before navigation
                      if (_selectedIndex != -1) {
                        var bottle =
                            bottleController.bottleItems[_selectedIndex];
                        double price = bottle['price'];
                        double vacantPrice =
                            _hasEmptyBottle ? bottle['vacantPrice'] : 0;

                        Get.toNamed(AppRoutes.subscription, arguments: {
                          'bottle': bottle,
                          'quantity': _quantity,
                          'price': price,
                          'vacantPrice': vacantPrice,
                          'hasEmptyBottle': _hasEmptyBottle,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      "Subscribe",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
