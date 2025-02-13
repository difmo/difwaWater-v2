import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Razorpay? _razorpay;
  TextEditingController amountController = TextEditingController();
  WalletController? walletController;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    walletController = WalletController(
      razorpay: _razorpay!,
      context: context,
      amountController: amountController,
    );

    _razorpay?.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, walletController!.handlePaymentSuccess);
    _razorpay?.on(
        Razorpay.EVENT_PAYMENT_ERROR, walletController!.handlePaymentError);
    _razorpay?.on(
        Razorpay.EVENT_EXTERNAL_WALLET, walletController!.handleExternalWallet);

    // Fetch user wallet balance and listen for updates
    walletController?.fetchUserWalletBalance();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Wallet',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Your Wallet Balance',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            // Display wallet balance with real-time updates
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
                  double walletBalance = userDoc['walletBalance'] ?? 0.0;
                  return Text(
                    '₹ ${walletBalance.toStringAsFixed(2)}',
                    
                      // "hgsjh",
                    style: const TextStyle(
                      color: Colors.blue,
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
            const Text(
              'Add money to your Watrify wallet to have a hassle-free booking experience.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  double amount = double.tryParse(amountController.text) ?? 0.0;
                  if (amount >= 30.0) {
                    walletController?.openCheckout(amount);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          const Text("Please enter an amount greater than ₹30"),
                    ));
                  }
                },
                child: const Text(
                  'Add Money To Wallet',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
