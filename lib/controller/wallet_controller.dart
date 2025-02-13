import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WalletController {
  final Razorpay razorpay;
  final BuildContext context;
  final TextEditingController amountController;
  String currentUserId = '';
  double walletBalance = 0.0;

  WalletController({
    required this.razorpay,
    required this.context,
    required this.amountController,
  });

  // Fetch current user's wallet balance in real-time from Firestore
  void fetchUserWalletBalance() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserId = currentUser.uid;

      // Listen to changes in the user's wallet balance in real-time
      FirebaseFirestore.instance
          .collection('difwa-users')
          .doc(currentUser.uid)
          .snapshots()
          .listen((userDoc) {
        if (userDoc.exists) {
          // Safely retrieve walletBalance field, if it exists
          walletBalance = userDoc.data()?['walletBalance'] ?? 0.0;
          print("Updated Wallet Balance: $walletBalance");
        } else {
          walletBalance = 0.0; // Default value if user document doesn't exist
        }
      }, onError: (e) {
        print("Error fetching wallet balance: $e");
      });
    } else {
      print("No user logged in.");
    }
  }

  // Handle payment success
  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Payment Successful: ${response.paymentId}"),
    ));

    // Add the entered amount to the wallet balance
    double addedAmount = double.tryParse(amountController.text) ?? 0.0;
    walletBalance += addedAmount;

    // Store order details in Firestore
    await storeOrder(response.paymentId ?? 'unknown', walletBalance);

    // Update the wallet balance in Firestore
    await FirebaseFirestore.instance
        .collection('difwa-users')
        .doc(currentUserId)
        .get()
        .then((doc) async {
      if (doc.exists) {
        await FirebaseFirestore.instance
            .collection('difwa-users')
            .doc(currentUserId)
            .update({'walletBalance': walletBalance});
      } else {
        await FirebaseFirestore.instance
            .collection('difwa-users')
            .doc(currentUserId)
            .set({'walletBalance': walletBalance});
      }
    }).catchError((error) {
      print("Error updating wallet balance: $error");
    });
  }

  // Handle payment error
  void handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Payment Failed: ${response.message}"),
    ));
  }

  // Handle external wallet
  void handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("External Wallet: ${response.walletName}"),
    ));
  }

  // Store order details in Firestore
  Future<void> storeOrder(String paymentId, double walletBalance) async {
    try {
      Map<String, dynamic> orderData = {
        'paymentId': paymentId,
        'userId': currentUserId,
        'walletBalance': walletBalance,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('difwaorders').add(orderData);
      print("Order successfully stored in Firestore.");
    } catch (e) {
      print("Error storing order: $e");
    }
  }

  // Open Razorpay checkout
  void openCheckout(double amount) async {
    var options = {
      'key': 'rzp_test_5JTg9I35AkiZMQ', // Replace with your Razorpay Key ID
      'amount': (amount * 100).toInt(),
      'name': 'Watrify Wallet',
      'description': 'Add money to your wallet',
      'prefill': {
        'contact': '7800730968',
        'email': 'test@example.com',
      },
      'theme': {
        'color': '#528FF0',
      },
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print("Error opening Razorpay checkout: $e");
    }
  }
}
