import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/wallet_controller.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  TextEditingController amountController = TextEditingController();
  WalletController? walletController;

  @override
  void initState() {
    super.initState();
    walletController = WalletController(
      context: context,
      amountController: amountController,
    );
    walletController?.fetchUserWalletBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 90),
            const Text(
              'Your Wallet Balance',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
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

                if (snapshot.hasData) {
                  var userDoc = snapshot.data!;
                  double walletBalance = (userDoc['walletBalance'] is int)
                      ? (userDoc['walletBalance'] as int).toDouble()
                      : (userDoc['walletBalance'] ?? 0.0);
                  return Text(
                    '₹ ${walletBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: ThemeConstants.primaryColorNew,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  );
                } else {
                  return const Text('No data');
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                hintText: 'Enter Amount',
                prefixIcon: const Icon(Icons.account_balance_wallet),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            SizedBox(
                width: double.infinity,
                child: CustomButton(
                  baseTextColor: ThemeConstants.whiteColor,
                  text: "Add Money",
                  onPressed: () {
                    double amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    walletController?.redirectToPaymentWebsite(amount);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
