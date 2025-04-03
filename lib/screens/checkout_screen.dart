import 'package:difwa/config/app_constant.dart';
import 'package:difwa/controller/address_controller.dart';
import 'package:difwa/controller/wallet_controller.dart';
import 'package:difwa/models/address_model.dart';
import 'package:difwa/screens/auth/saved_address.dart';
import 'package:difwa/utils/app__text_style.dart';
import 'package:difwa/utils/generators.dart';
import 'package:difwa/widgets/subscribe_button_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/controller/checkout_controller.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;
  final double totalPrice;
  final int totalDays;
  final List<DateTime> selectedDates;

  const CheckoutScreen({
    super.key,
    required this.orderData,
    required this.totalPrice,
    required this.totalDays,
    required this.selectedDates,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final CheckoutController checkoutController;
  late final AddressController _addressController;
  final WalletController _walletController2 = Get.put(WalletController());
  Address? addresss;
  String? userUid = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();
    checkoutController = Get.put(CheckoutController());
    _addressController = Get.put(AddressController());
    checkoutController.fetchWalletBalance();
    // _getSelectedAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Checkout', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Card
            Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        bottleImageUrl,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text("${widget.orderData['bottle']['size']}L",
                              style: AppTextStyle.TextWhite18700),
                          SizedBox(height: 4),
                          Text(
                              "Price: ₹ ${widget.orderData['price']} per bottle",
                              style: AppTextStyle.TextWhite16700),
                          Text(
                              "Vacant Bottle Price: ₹ ${widget.orderData['vacantPrice'] * widget.orderData['quantity']}",
                              style: AppTextStyle.TextWhite16700),
                          Text("One Bottle Price: ₹ ${widget.totalPrice}",
                              style: AppTextStyle.TextWhite16700),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Calendar Widget
            Container(
              decoration: BoxDecoration(
                color: ThemeConstants.whiteColor,
                border:
                    Border.all(color: ThemeConstants.secondaryLight, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'April 2025',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '2 weeks',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: DateTime.now(),
                    headerVisible: false,
                    selectedDayPredicate: (day) {
                      return widget.selectedDates
                          .any((selectedDate) => isSameDay(selectedDate, day));
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      defaultDecoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                    daysOfWeekVisible: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Days:", style: AppTextStyle.Text14500),
                      Text("${widget.totalDays} days",
                          style: AppTextStyle.Text16700),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Price:",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        "₹${widget.orderData['price'] * widget.totalDays + widget.orderData['vacantPrice'] * widget.orderData['quantity']} ",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text('Your Wallet Balance:', style: TextStyle(fontSize: 14)),

            // Wallet Balance Display
            Obx(() {
              return Text(
                '₹ ${checkoutController.walletBalance.value.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              );
            }),

            const SizedBox(height: 24),
            StreamBuilder<Address?>(
              stream: _addressController.getSelectedAddress(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData && snapshot.data != null) {
                  final address = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${address.name}, ${address.street}, ${address.city}, ${address.state}, ${address.zip}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Country: ${address.country}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Phone: ${address.phone}',
                          style: const TextStyle(fontSize: 14)),
                      TextButton(
                        onPressed: () async {
                          final Address? newAddress =
                              await Get.to(() => SavveAddressPage());
                          if (newAddress != null) {
                            // _addressController.updateSelectedAddress(newAddress);
                          }
                        },
                        child: const Text('Change Address',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                } else {
                  return const Text('No address selected.');
                }
              },
            ),

            // Payment Button
            SubscribeButtonComponent(
                text: 'Pay Now',
                onPressed: () async {
                  if (await _addressController.hasAddresses()) {
                    print("selected address");

                    await checkoutController.processPayment(
                        widget.orderData,
                        widget.orderData['price'],
                        widget.totalDays,
                        (widget.orderData['vacantPrice'] *
                                widget.orderData['quantity'])
                            .toDouble(),
                        widget.selectedDates,
                        context);

                    await _walletController2.saveWalletHistory(
                        widget.orderData['price'],
                        "Debited",
                        Generators.generatePaymentId(),
                        "Success",
                        userUid);
                  } else {
                    print("Please Create An Address");
                  }
                }),
          ],
        ),
      ),
    );
  }
}
