import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletController {
  final BuildContext context;
  final TextEditingController amountController;
  String currentUserId = '';
  double walletBalance = 0.0;

  WalletController({
    required this.context,
    required this.amountController,
  });

  void fetchUserWalletBalance() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserId = currentUser.uid;

      FirebaseFirestore.instance
          .collection('difwa-users')
          .doc(currentUser.uid)
          .snapshots()
          .listen((userDoc) {
        if (userDoc.exists) {
          walletBalance = userDoc.data()?['walletBalance'] ?? 0.0;
          print("Updated Wallet Balance: $walletBalance");
        } else {
          walletBalance = 0.0; 
        }
      }, onError: (e) {
        print("Error fetching wallet balance: $e");
      });
    } else {
      print("No user logged in.");
    }
  }

  void redirectToPaymentWebsite(double amount) async {
    if (amount >= 30.0) {
      String url = 'https://www.difwa.com/payment-page?amount=$amount&userId=$currentUserId';

      try {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        print("Error launching payment page: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Please enter an amount greater than ₹30"),
      ));
    }
  }

  void updateWalletBalance(dynamic addedAmount) async {
    if (addedAmount is int) {
      addedAmount = addedAmount.toDouble();
    }

    walletBalance += addedAmount;

    try {
      await FirebaseFirestore.instance
          .collection('difwa-users')
          .doc(currentUserId)
          .update({'walletBalance': walletBalance});
      print("Wallet balance updated successfully.");
    } catch (e) {
      print("Error updating wallet balance: $e");
    }
  }
}
