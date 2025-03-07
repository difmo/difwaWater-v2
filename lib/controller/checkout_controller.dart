import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:difwa/screens/congratulations_page.dart';

class CheckoutController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUserId = '';
  String? merchantId;
  RxDouble walletBalance = 0.0.obs;

  Future<void> fetchWalletBalance() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserId = currentUser.uid;
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('difwa-users').doc(currentUserId).get();
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

  // Fetch the merchant ID for the current user
  Future<void> fetchMerchantId() async {
    try {
      DocumentSnapshot storeSnapshot =
          await _firestore.collection('stores').doc(currentUserId).get();

      if (!storeSnapshot.exists) {
        print(
            "Error fetching merchant ID: Store document does not exist for this user.");
        Get.snackbar("Error", "Store document does not exist for this user.");
        return; // Exit or create the store document
      }

      merchantId = storeSnapshot['merchantId'];
      print("Merchant ID: $merchantId");
    } catch (e) {
      print("Error fetching merchant ID: $e");
      Get.snackbar("Error", "Failed to fetch merchant ID: $e");
    }
  }

  // Get the latest order IDs and increment them globally
  Future<Map<String, int>> getNextOrderIds() async {
    try {
      // Fetch the last Bulk and Daily Order ID from Firestore
      DocumentSnapshot bulkOrderDoc = await _firestore
          .collection('difwa-order-counters')
          .doc('lastBulkOrderId')
          .get();
      DocumentSnapshot dailyOrderDoc = await _firestore
          .collection('difwa-order-counters')
          .doc('lastDailyOrderId')
          .get();

      int newBulkOrderId = 1;
      int newDailyOrderId = 1;

      if (bulkOrderDoc.exists) {
        newBulkOrderId = (bulkOrderDoc['id'] as int) + 1;
      }

      if (dailyOrderDoc.exists) {
        newDailyOrderId = (dailyOrderDoc['id'] as int) + 1;
      }

      // Update Firestore with the new Bulk and Daily Order IDs
      await _firestore
          .collection('difwa-order-counters')
          .doc('lastBulkOrderId')
          .set({'id': newBulkOrderId});
      await _firestore
          .collection('difwa-order-counters')
          .doc('lastDailyOrderId')
          .set({'id': newDailyOrderId});

      // Return the new order IDs
      return {'bulkOrderId': newBulkOrderId, 'dailyOrderId': newDailyOrderId};
    } catch (e) {
      print("Error fetching or updating order IDs: $e");
      rethrow;
    }
  }

  // Process the payment
  Future<void> processPayment(
      Map<String, dynamic> orderData,
      double totalPrice,
      int totalDays,
      double vacantBottlePrice,
      List<DateTime> selectedDates) async {
    double totalAmount = totalPrice * totalDays + vacantBottlePrice;

    if (walletBalance.value >= totalAmount) {
      double newBalance = walletBalance.value - totalAmount;

      try {
        // Get the next order IDs
        Map<String, int> orderIds = await getNextOrderIds();
        int newBulkOrderId = orderIds['bulkOrderId']!;
        int newDailyOrderId = orderIds['dailyOrderId']!;

        // For each selected date, assign a unique dailyOrderId
        List<Map<String, dynamic>> selectedDatesWithHistory = [];
        for (int i = 0; i < selectedDates.length; i++) {
          selectedDatesWithHistory.add({
            'date': selectedDates[i].toIso8601String(),
            'statusHistory': [
              {
                'dailyOrderId': (newDailyOrderId + i)
                    .toString(), // Increment dailyOrderId for each day
                'status': 'pending',
                'time': Timestamp.now(),
              }
            ],
          });
        }

        // Update wallet balance
        await _firestore
            .collection('difwa-users')
            .doc(currentUserId)
            .update({'walletBalance': newBalance});

        // Create the order with the new bulkOrderId and dailyOrderId
        await _firestore.collection('difwa-orders').add({
          'bulkOrderId': newBulkOrderId,
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

        await _firestore
            .collection('difwa-order-counters')
            .doc('lastDailyOrderId')
            .update({
          'id': newDailyOrderId - 1 + totalDays,
        });
      } catch (e) {
        print("Error processing payment: $e");
        Get.snackbar("Error", "Error processing payment: $e");
      }
    } else {
      Get.snackbar("Insufficient Balance", "Please add funds to your wallet.");
    }
  }
}
