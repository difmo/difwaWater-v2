import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/config/app_color.dart';
import 'package:difwa/controller/bottle_controller.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/custom_appbar.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../widgets/ImageCarouselApp.dart';

class BookNowScreen extends StatefulWidget {
  const BookNowScreen({super.key});

  @override
  _BookNowScreenState createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  int _selectedIndex = -1;
  bool _hasEmptyBottle = false;
  int _quantity = 1;
List<Map<String, dynamic>> _bottleItems = [];

  @override
  void initState() {
    super.initState();
    fetchBottleItems();
  }
Future<void> fetchBottleItems() async {
  try {
    List<Map<String, dynamic>> fetchedItems = [];
    QuerySnapshot storeSnapshot = await FirebaseFirestore.instance.collection('difwa-stores').get();

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
      });
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
}

  // Update state after all Firestore calls are completed
//   setState(() {
//     _bottleItems = fetchedItems;
//   });
// }

  @override
  Widget build(BuildContext context) {
    final BottleController bottleController = Get.put(BottleController());
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
          onProfilePressed: () {},
          onNotificationPressed: () {
            Get.toNamed(AppRoutes.notification);
          },
          onMenuPressed: () {},
          hasNotifications: true,
          badgeCount: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.20,
                child: const ImageCarouselPage(),
              ),
              if (_bottleItems.isEmpty)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    // Divider(
                    //   color: AppColors.darkGrey,
                    //   thickness: 1,
                    //   height: 20,
                    //   indent: 10,
                    //   endIndent: 10,
                    // ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _bottleItems.length,
                        itemBuilder: (context, index) {
                          var bottle = _bottleItems[index];
                          bool isSelected = index == _selectedIndex;

                          String imageUrl = bottle['imageUrl'] ?? 'https://5.imimg.com/data5/RK/MM/MY-26385841/ff-1000x1000.jpg';

                          return GestureDetector(
                            onTap: () {
                              print("index");
                              print(index);
                              setState(() {

                                _selectedIndex = isSelected ? -1 : index;
                              });
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: BorderSide(
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                              ),
                              elevation: 0,
                              color: isSelected
                                  ? ThemeConstants.whiteColor
                                  : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.image_not_supported,
                                            size: 80, color: Colors.grey);
                                      },
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
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: const BorderSide(
                      width: 1,
                      color: Color(0xFF02739C),
                    ),
                  ),
                  elevation: 0,
                  color: const Color.fromARGB(255, 22, 174, 229),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: SvgPicture.asset(
                            "assets/elements/homecard.svg",
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(16.0)),
                          child: SvgPicture.asset(
                            "assets/elements/homecardbottle.svg",
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Choose the number of bottles you would like to buy.',
                                style: TextStyle(
                                  color: ThemeConstants.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
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
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      size: 32,
                                      color:
                                          Colors.white, // Change color to white
                                    ),
                                  ),
                                  Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      color: ThemeConstants.whiteColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _quantity++; // Increase bottle count
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_up,
                                      size: 32,
                                      color:
                                          Colors.white, // Change color to white
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: ThemeConstants.whiteColor,
                                    checkColor: Colors
                                        .blue, // Ensure checkmark is white
                                    value:
                                        _hasEmptyBottle, // Bind the checkbox state
                                    onChanged: (value) {
                                      setState(() {
                                        _hasEmptyBottle =
                                            value ?? false; // Update state
                                      });
                                    },
                                  ),
                                  const Expanded(
                                    child: Text(
                                      "I don't have empty bottles to return",
                                      style: TextStyle(
                                        color: ThemeConstants.whiteColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (_selectedIndex !=
                                  -1) // Show selected bottle details
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Water Price:',
                                          style: TextStyle(
                                              color: ThemeConstants.whiteColor),
                                        ),
                                        Text(
                                          '₹ ${_bottleItems[_selectedIndex]['price']}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: ThemeConstants
                                                  .backgroundColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Bottle Price:',
                                          style: TextStyle(
                                              color: ThemeConstants.whiteColor),
                                        ),
                                        Text(
                                          _hasEmptyBottle
                                              ? '₹ ${_bottleItems[_selectedIndex]['vacantPrice']}'
                                              : '₹ 0', // If not checked, no bottle price
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: ThemeConstants
                                                  .backgroundColor),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total Price:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '₹ ${(_quantity * _bottleItems[_selectedIndex]['price']) + (_hasEmptyBottle ? (_quantity * _bottleItems[_selectedIndex]['vacantPrice']) : 0)}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // CustomButton(
                  //     text: "Order Now",
                  //     baseTextColor: ThemeConstants.whiteColor,
                  //     onPressed: () {}),
                  CustomButton(
                    text: "Take Subscription",
                    baseTextColor: ThemeConstants.whiteColor,
                    width: 150,
                    onPressed: () {
                      if (_selectedIndex != -1) {
                        var bottle =
                            _bottleItems[_selectedIndex];
                        double price = bottle['price'];
                        double vacantPrice =
                            _hasEmptyBottle ? bottle['vacantPrice'] : 0;

                        Get.toNamed(
                          AppRoutes.subscription,
                          arguments: {
                            'bottle': bottle,
                            'quantity': _quantity,
                            'price': price,
                            'vacantPrice': vacantPrice,
                            'hasEmptyBottle': _hasEmptyBottle,
                          },
                        );
                      } else {
                        Get.dialog(
                          AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text("Select a Bottle"),
                            content: Text(
                                "Please select a bottle before proceeding"),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
