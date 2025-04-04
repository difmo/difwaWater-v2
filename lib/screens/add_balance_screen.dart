import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/wallet_controller.dart';
import 'package:difwa/screens/payment_webview_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddBalanceScreen extends StatefulWidget {
  const AddBalanceScreen({super.key});

  @override
  State<AddBalanceScreen> createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {
  TextEditingController amountController = TextEditingController();
  WalletController? walletController;
  final WalletController _walletController2 = Get.put(WalletController());
  String? userUid = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();
    walletController = WalletController();
    // walletController?.fetchUserWalletBalance();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double currentBalance = 2458.65;
  double enteredAmount = 0.0;
  String selectedPaymentMethod = "Visa ending in 4242";
  String paymentId = "";

  final List<Map<String, String>> paymentMethods = [
    {"type": "visa", "card": "Visa ending in 4242", "expiry": "Expires 12/24"},
    {
      "type": "mastercard",
      "card": "Mastercard ending in 8790",
      "expiry": "Expires 09/25"
    },
    {"type": "add", "card": "Add New Payment Method", "expiry": ""}
  ];

  // Function to handle amount button taps
  void _addQuickAmount(double amount) {
    setState(() {
      double newAmount = (double.tryParse(amountController.text) ?? 0) + amount;
      amountController.text = newAmount.toStringAsFixed(2);
      enteredAmount = newAmount;
    });
  }

  // Function to select payment method
  void _selectPaymentMethod(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

  void redirectToPaymentWebsite(double amount, String? currentUserId) async {
    if (amount >= 30.0) {
      String url =
          'https://www.difwa.com/payment-page?amount=$amount&userId=$currentUserId&returnUrl=app://payment-result';

      // Open WebView and wait for the result
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebViewScreen(
            initialUrl: url,
            amount: amount,
            userId: currentUserId!,
          ),
        ),
      );
      print("Payment Status from add balance: $result");

      if (result != null && result is Map<String, dynamic>) {
        String status = result['status'] ?? 'No status';
        String paymentId = result['payment_id'] ?? 'No payment_id';
        print("Payment Status from add balance: $status");
        print("Payment ID: $paymentId");
        await _walletController2.saveWalletHistory(amount, "Credited",
            paymentId, status, userUid);
        // Now you can use the correct paymentId here
      } else {
        print("No result returned from PaymentWebViewScreen.");
      }

      _addMoneySuccess(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Please enter an amount greater than ₹30"),
      ));
    }
  }

  // Function to handle the "Add Money" button
  void _addMoney() {
    if (enteredAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount!")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Adding ₹ ${enteredAmount.toStringAsFixed(2)} to your balance",
        ),
      ),
    );

    var currentUserId = FirebaseAuth.instance.currentUser?.uid;
    redirectToPaymentWebsite(enteredAmount, currentUserId);
  }

  // Function to handle the "Add Money" button
  void _addMoneySuccess(result) {
    if (enteredAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount!")),
      );
      return;
    }
    print("result");
    print(result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "₹ \$${enteredAmount.toStringAsFixed(2)} Added To Your Wallet",
        ),
      ),
    );
    // Simulate balance update
    setState(() {
      currentBalance += enteredAmount;
      amountController.clear();
      enteredAmount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Balance",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance Display
            const Text(
              "Current Balance",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 4),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('difwa-users')
                  .doc(walletController?.currentUserIdd)
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
                  walletBalance = (userDoc['walletBalance'] as num).toDouble();
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
            const SizedBox(height: 20),

            // Amount Input Field
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              onChanged: (value) => setState(() {
                enteredAmount = double.tryParse(value) ?? 0;
              }),
              decoration: InputDecoration(
                prefixText: "₹ ",
                hintText: "0.00",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Quick Amount Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [10, 20, 50, 100]
                  .map(
                    (amount) => ElevatedButton(
                      onPressed: () => _addQuickAmount(amount.toDouble()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                      ),
                      child: Text("+₹${amount.toString()}"),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Payment Method Section
            const Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Payment Methods List
            ...paymentMethods.map((method) {
              return _buildPaymentMethodTile(
                iconPath: "assets/icons/${method['type']}.svg",
                cardEnding: method['card']!,
                expiry: method['expiry']!,
                isSelected: selectedPaymentMethod == method['card'],
                onSelect: () => _selectPaymentMethod(method['card']!),
              );
            }),

            const SizedBox(height: 10),

            // Fee Notice
            const Text(
              "A 1.5% processing fee may apply. Funds typically arrive within 24 hours.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 20),

            // Add Money Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addMoney,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add Money",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Payment Method Tile Widget
  Widget _buildPaymentMethodTile({
    required String iconPath,
    required String cardEnding,
    String? expiry,
    bool isSelected = false,
    required VoidCallback onSelect,
  }) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ListTile(
          leading: iconPath.isNotEmpty
              ? SvgPicture.asset(iconPath, height: 28)
              : const Icon(Icons.add_circle_outline, color: Colors.grey),
          title: Text(
            cardEnding,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.grey[700],
            ),
          ),
          subtitle: expiry != null ? Text(expiry) : null,
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.black)
              : null,
        ),
      ),
    );
  }
}
