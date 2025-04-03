import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/wallet_controller.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatefulWidget {
  final VoidCallback onProfilePressed;
  final VoidCallback onMenuPressed;
  const WalletScreen(
      {super.key, required this.onProfilePressed, required this.onMenuPressed});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  TextEditingController amountController = TextEditingController();
  WalletController? walletController;
  late StreamSubscription _sub;
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    walletController = WalletController(
      context: context,
      amountController: amountController,
    );
    walletController?.fetchUserWalletBalance();
    _initAppLinks();
  }

  Future<void> _initAppLinks() async {
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      _handleDeepLink(uri);
    });
    Uri? initialLink = await _appLinks.getInitialLink();
    _handleDeepLink(initialLink);
  }

  void _handleDeepLink(Uri? uri) {
    if (uri != null && uri.toString().contains('app://payment-result')) {
      bool paymentSuccess = _checkPaymentStatus(uri.toString());
      if (paymentSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Payment successful!"),
        ));
        walletController?.updateWalletBalance(50.0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Payment failed. Please try again."),
        ));
      }
    }
  }

  bool _checkPaymentStatus(String link) {
    // Assuming that the URL contains the word "success" if payment was successful
    return link.contains("success");
  }

  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppbar(
            onProfilePressed: widget.onProfilePressed,
            onNotificationPressed: () {
              Get.toNamed(
                  AppRoutes.notification); // Navigate to notifications page
            },
            onMenuPressed: widget.onMenuPressed,
            hasNotifications: true,
            badgeCount: 5, // Example badge count
            profileImageUrl:
                'https://i.ibb.co/CpvLnmGf/cheerful-indian-businessman-smiling-closeup-portrait-jobs-career-campaign.jpg', // Profile picture URL
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Balance Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Balance",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('difwa-users')
                        .doc(walletController?.currentUserId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

// Check if data exists
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Text(
                          "₹ 0.0",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      // Extract document data
                      var userDoc = snapshot.data!;
                      double walletBalance = 0.0;

                      if (userDoc.data() != null &&
                          userDoc['walletBalance'] != null) {
                        walletBalance =
                            (userDoc['walletBalance'] as num).toDouble();
                      }

                      return Text(
                        "₹ ${walletBalance.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.addbalance_screen);
                      },
                      child: const Text(
                        "Add Balance",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "See All",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Transaction List
            _buildTransactionItem(
              icon: Icons.arrow_downward,
              color: Colors.green,
              title: "Received from \nJames Wilson",
              date: "Oct 24, 2023 • Completed",
              amount: "+₹850.00",
              amountColor: Colors.green,
            ),
            _buildTransactionItem(
              icon: Icons.arrow_upward,
              color: Colors.red,
              title: "Amazon Purchase",
              date: "Oct 23, 2023 • Completed",
              amount: "-₹129.99",
              amountColor: Colors.red,
            ),
            _buildTransactionItem(
              icon: Icons.access_time,
              color: Colors.orange,
              title: "Netflix Subscription",
              date: "Oct 22, 2023 • Pending",
              amount: "-₹14.99",
              amountColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required Color color,
    required String title,
    required String date,
    required String amount,
    required Color amountColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
