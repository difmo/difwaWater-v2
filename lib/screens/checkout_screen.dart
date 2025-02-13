import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/admin_controller/add_items_controller.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;
  final double totalPrice;
  final int totalDays;
  final List<DateTime> selectedDates;

  const CheckoutScreen({
    required this.orderData,
    required this.totalPrice,
    required this.totalDays,
    required this.selectedDates,
    Key? key,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double walletBalance = 0.0;
  String currentUserId = '';
  String? merchantId;

  @override
  void initState() {
    super.initState();
    _fetchWalletBalance();
    _fetchMerchantId(); // Fetch merchantId when the screen initializes
  }

  void _fetchWalletBalance() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserId = currentUser.uid;

      if (currentUserId.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('difwa-users')
            .doc(currentUserId)
            .get()
            .then((userDoc) {
          if (userDoc.exists) {
            setState(() {
              walletBalance = userDoc['walletBalance'] ?? 0.0;
            });
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User not logged in or invalid user ID.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user logged in.')),
      );
    }
  }

  void _fetchMerchantId() async {
    try {
      FirebaseController firebaseController = FirebaseController();
      String? fetchedMerchantId =
          await firebaseController.fetchMerchantId(currentUserId);
      setState(() {
        merchantId = fetchedMerchantId;
      });
    } catch (e) {
      print('Failed to fetch merchantId: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch merchant ID')),
      );
    }
  }

  void _processPayment() async {
    double vacantBottlePrice =
        widget.orderData['vacantPrice'] * widget.orderData['quantity'];
    double totalAmount =
        widget.totalPrice * widget.totalDays + vacantBottlePrice;

    if (walletBalance >= totalAmount) {
      double newBalance = walletBalance - totalAmount;

      try {
        Timestamp currentTimestamp = Timestamp.now();

        await FirebaseFirestore.instance
            .collection('difwa-users')
            .doc(currentUserId)
            .update({'walletBalance': newBalance});

        List<Map<String, dynamic>> selectedDatesWithHistory =
            widget.selectedDates
                .map((date) => {
                      'date': date.toIso8601String(),
                      'statusHistory': [
                        {
                          'status': 'pending',
                          'time': currentTimestamp,
                        }
                      ],
                    })
                .toList();

        await FirebaseFirestore.instance.collection('difwa-orders').add({
          'userId': currentUserId,
          'totalPrice': totalAmount,
          'totalDays': widget.totalDays,
          'selectedDates': selectedDatesWithHistory,
          'orderData': widget.orderData,
          'status': 'paid',
          'timestamp': FieldValue.serverTimestamp(),
          'merchantId': merchantId,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CongratulationsPage()),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing payment: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Insufficient balance. Please add funds to your wallet.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double vacantBottlePrice =
        widget.orderData['vacantPrice'] * widget.orderData['quantity'];
    double totalAmount =
        widget.totalPrice * widget.totalDays + vacantBottlePrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            Text(
                              '${widget.orderData['bottle']['size']}L',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Price: ₹ ${widget.orderData['price']} per bottle',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text('One Bottle Price: ₹ ${widget.totalPrice}'),
                            Text('Vacant Bottle Price: ₹ ${vacantBottlePrice}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Selected Dates:'),
              ...widget.selectedDates
                  .map((date) => Text(DateFormat('yyyy-MM-dd').format(date)))
                  .toList(),
              const SizedBox(height: 16),
              Text('Total Days: ${widget.totalDays} days'),
              const SizedBox(height: 16),
              Text(
                'Total Price: ₹ ${totalAmount}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 16),
              const Text('Your Wallet Balance:'),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('difwa-users')
                    .doc(currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.hasData) {
                    var userDoc = snapshot.data!;
                    double balance = userDoc['walletBalance'] ?? 0.0;
                    return Text(
                      '₹ ${balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    );
                  } else {
                    return const Text('No data');
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _processPayment,
                child: const Text('Pay using Wallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CongratulationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(AppRoutes
            .userbottom); // This will navigate to home and remove all previous routes
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Congratulations')),
        body: const Center(
          child: Text(
            'Your payment was successful!\nThank you for your order.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
