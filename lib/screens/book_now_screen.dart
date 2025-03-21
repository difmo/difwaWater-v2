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
            onNotificationPressed: () {},
            onMenuPressed: () {},
            hasNotifications: true),
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
              Obx(() {
                if (bottleController.bottleItems.isEmpty) {
                  return const CircularProgressIndicator();
                }

                return Column(
                  children: [
                    Divider(
                      color: AppColors.darkGrey,
                      thickness: 1,
                      height: 20,
                      indent: 10,
                      endIndent: 10,
                    ),
                    SizedBox(
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
                                  'https://5.imimg.com/data5/RK/MM/MY-26385841/ff-1000x1000.jpg';
                              break;
                            case 20:
                              imagePath =
                                  'https://5.imimg.com/data5/RK/MM/MY-26385841/ff-1000x1000.jpg';
                              break;
                            case 10:
                              imagePath =
                                  'https://5.imimg.com/data5/RK/MM/MY-26385841/ff-1000x1000.jpg';
                              break;
                            default:
                              imagePath =
                                  'https://5.imimg.com/data5/RK/MM/MY-26385841/ff-1000x1000.jpg';
                              break;
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
                                side: const BorderSide(
                                  color: Colors.blue, // Border color
                                  width: 1.0, // Border width
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
                                      imagePath,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.image_not_supported,
                                            size: 80, color: Colors.grey);
                                      },
                                    ),

                                    // Image.asset(
                                    //   imagePath,
                                    //   width: 80,
                                    //   height: 80,
                                    //   fit: BoxFit.cover,
                                    // ),
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
                );
              }),
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
                  color: const Color(0xFF00597A),
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
                                        .white, // Ensure checkmark is white
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
                                          '₹ ${bottleController.bottleItems[_selectedIndex]['price']}',
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
                                              ? '₹ ${bottleController.bottleItems[_selectedIndex]['vacantPrice']}'
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
                                          '₹ ${(_quantity * bottleController.bottleItems[_selectedIndex]['price']) + (_hasEmptyBottle ? (_quantity * bottleController.bottleItems[_selectedIndex]['vacantPrice']) : 0)}',
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                      text: "Order Now",
                      baseTextColor: ThemeConstants.whiteColor,
                      onPressed: () {}),
                  CustomButton(
                    text: "Take Subscription",
                    baseTextColor: ThemeConstants.whiteColor,
                    width: 150,
                    onPressed: () {
                      if (_selectedIndex != -1) {
                        var bottle =
                            bottleController.bottleItems[_selectedIndex];
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
