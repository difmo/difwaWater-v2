import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/admin_controller/add_items_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:difwa/screens/congratulations_page.dart';

class CheckoutController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUserId = ''; 
  String? merchantId;
  RxDouble walletBalance = 0.0.obs;

  void fetchWalletBalance() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserId = currentUser.uid;
      try {
        DocumentSnapshot userDoc = await _firestore.collection('difwa-users').doc(currentUserId).get();
        if (userDoc.exists) {
          walletBalance.value = (userDoc['walletBalance'] is int)
              ? (userDoc['walletBalance'] as int).toDouble()
              : (userDoc['walletBalance'] ?? 0.0);
        }
      } catch (e) {
        print("Error fetching wallet balance: $e");
      }
    }
  }

  Future<void> fetchMerchantId() async {
    try {
      FirebaseController firebaseController = FirebaseController();
      merchantId = await firebaseController.fetchMerchantId(currentUserId);
    } catch (e) {
      print("Error fetching merchant ID: $e");
    }
  }

  // Get next bulk order ID
  Future<String> getNextBulkOrderId() async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('orderCounters').doc('counters').get();
      int currentBulkOrderId = snapshot['difwa-bulkOrderCounter'];
      int nextBulkOrderId = currentBulkOrderId + 1;
      await _firestore.collection('orderCounters').doc('counters').update({'difwa-bulkOrderCounter': nextBulkOrderId});
      return nextBulkOrderId.toString();
    } catch (e) {
      print("Error getting next bulkOrderId: $e");
      return '';
    }
  }

  // Get next daily order ID
  Future<String> getNextDailyOrderId() async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('difwa-orderCounters').doc('counters').get();
      int currentDailyOrderId = snapshot['difwa-dailyOrderCounter'];
      int nextDailyOrderId = currentDailyOrderId + 1;
      await _firestore.collection('orderCounters').doc('counters').update({'dailyOrderCounter': nextDailyOrderId});
      return nextDailyOrderId.toString();
    } catch (e) {
      print("Error getting next dailyOrderId: $e");
      return '';
    }
  }

  // Process the payment
  Future<void> processPayment(Map<String, dynamic> orderData, double totalPrice, int totalDays, double vacantBottlePrice, List<DateTime> selectedDates) async {
    double totalAmount = totalPrice * totalDays + vacantBottlePrice;

    if (walletBalance.value >= totalAmount) {
      double newBalance = walletBalance.value - totalAmount;
      try {
        Timestamp currentTimestamp = Timestamp.now();

        String nextBulkOrderId = await getNextBulkOrderId();
        String nextDailyOrderId = await getNextDailyOrderId();

        await _firestore.collection('difwa-users').doc(currentUserId).update({'walletBalance': newBalance});

        List<Map<String, dynamic>> selectedDatesWithHistory = selectedDates
            .map((date) => {
                  'date': date.toIso8601String(),
                  'statusHistory': [
                    {
                      'dailyOrderId': nextDailyOrderId,
                      'status': 'pending',
                      'time': currentTimestamp,
                    }
                  ],
                })
            .toList();

        await _firestore.collection('difwa-orders').add({
          'bulkOrderId': nextBulkOrderId,
          'userId': currentUserId,
          'totalPrice': totalAmount,
          'totalDays': totalDays,
          'selectedDates': selectedDatesWithHistory,
          'orderData': orderData,
          'status': 'paid',
          'timestamp': FieldValue.serverTimestamp(),
          'merchantId': merchantId,
        });

        Get.to(() => CongratulationsPage());
      } catch (e) {
        print("Error processing payment: $e");
        Get.snackbar("Error", "Error processing payment: $e");
      }
    } else {
      Get.snackbar("Insufficient Balance", "Please add funds to your wallet.");
    }
  }
}
