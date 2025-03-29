import 'package:difwa/utils/app__text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/controller/checkout_controller.dart'; // Import the controller

class CheckoutScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final double totalPrice;
  final int totalDays; // Ensure this is int
  final List<DateTime> selectedDates;

  const CheckoutScreen({super.key, 
    required this.orderData,
    required this.totalPrice,
    required this.totalDays, // Must be int
    required this.selectedDates,
  });

  @override
  Widget build(BuildContext context) {
    final CheckoutController checkoutController = Get.put(CheckoutController());
    checkoutController.fetchWalletBalance();
    // checkoutController.fetchMerchantId();

    // double vacantBottlePrice = orderData['vacantPrice'] * orderData['quantity'];
    // double totalAmount = totalPrice * totalDays + vacantBottlePrice;
    double vacantBottlePrice = (orderData['vacantPrice'] as num).toDouble() *
        (orderData['quantity'] as num).toDouble();

    double totalAmount = totalPrice * totalDays.toDouble() + vacantBottlePrice;

    return Scaffold(
      backgroundColor: ThemeConstants.whiteColor,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Details Card
              Card(
                color: ThemeConstants.primaryColorNew,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1, color: ThemeConstants.primaryColorNew),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      Image.asset(
                        'assets/images/water.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${orderData['bottle']['size']}L',
                                style: AppTextStyle.Text12400.copyWith(
                                    color: ThemeConstants.whiteColor)),
                            const SizedBox(height: 8),
                            Text('Price: ₹ ${orderData['price']} per bottle',
                                style: AppTextStyle.Text12400.copyWith(
                                    color: ThemeConstants.whiteColor)),
                            const SizedBox(height: 8),
                            Text('One Bottle Price: ₹ $totalPrice',
                                style: AppTextStyle.Text12400.copyWith(
                                    color: ThemeConstants.whiteColor)),
                            Text('Vacant Bottle Price: ₹ $vacantBottlePrice',
                                style: AppTextStyle.Text12400.copyWith(
                                    color: ThemeConstants.whiteColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Calendar Widget
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeConstants.whiteColor,
                    border: Border.all(
                      color: ThemeConstants.secondaryLight,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: DateTime.now(),
                    selectedDayPredicate: (day) {
                      return selectedDates
                          .any((selectedDate) => isSameDay(selectedDate, day));
                    },
                    calendarStyle: const CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: ThemeConstants.primaryColorNew,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      defaultDecoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text('Total Days: $totalDays days'),
              const SizedBox(height: 16),
              Text(
                'Total Price: ₹ $totalAmount',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 16),
              const Text('Your Wallet Balance:'),

              // Wallet Balance Stream
              Obx(() {
                return checkoutController.walletBalance.value == 0.0
                    ? const CircularProgressIndicator()
                    : Text(
                        '₹ ${checkoutController.walletBalance.value.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      );
              }),

              const SizedBox(height: 16),

              // Payment Button
              ElevatedButton(
                onPressed: () {
                  checkoutController.processPayment(orderData, totalPrice,
                      totalDays, vacantBottlePrice, selectedDates);
                },
                child: const Text('Pay using Wallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
