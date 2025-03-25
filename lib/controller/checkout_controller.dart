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

  Future<Map<String, String>> getNextOrderIds() async {
    try {
      int currentYear = DateTime.now().year;

      DocumentSnapshot bulkOrderDoc = await _firestore
          .collection('difwa-order-counters')
          .doc('lastBulkOrderId')
          .get();
      DocumentSnapshot dailyOrderDoc = await _firestore
          .collection('difwa-order-counters')
          .doc('lastDailyOrderId')
          .get();

      int newBulkOrderNumber = 1;
      int newDailyOrderNumber = 1;

      if (bulkOrderDoc.exists) {
        newBulkOrderNumber = (bulkOrderDoc['id'] as int) + 1;
      }

      if (dailyOrderDoc.exists) {
        newDailyOrderNumber = (dailyOrderDoc['id'] as int) + 1;
      }

      String formattedBulkOrderId =
          'DIF$currentYear${newBulkOrderNumber.toString().padLeft(6, '0')}';
      String formattedDailyOrderId =
          'DIF$currentYear${newDailyOrderNumber.toString().padLeft(6, '0')}';

      await _firestore
          .collection('difwa-order-counters')
          .doc('lastBulkOrderId')
          .set({'id': newBulkOrderNumber});
      await _firestore
          .collection('difwa-order-counters')
          .doc('lastDailyOrderId')
          .set({'id': newDailyOrderNumber});

      return {
        'bulkOrderId': formattedBulkOrderId,
        'dailyOrderId': formattedDailyOrderId
      };
    } catch (e) {
      print("Error fetching or updating order IDs: $e");
      rethrow;
    }
  }

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
        Map<String, String> orderIds = await getNextOrderIds();
        String newBulkOrderId = orderIds['bulkOrderId']!;
        String newDailyOrderId = orderIds['dailyOrderId']!;

        List<Map<String, dynamic>> selectedDatesWithHistory = [];
        for (int i = 0; i < selectedDates.length; i++) {
          String formattedDailyOrderId = 'DIF${DateTime.now().year}${(int.parse(newDailyOrderId
                          .split(DateTime.now().year.toString())[1]) +
                      i)
                  .toString()
                  .padLeft(6, '0')}';
          selectedDatesWithHistory.add({
            'date': selectedDates[i].toIso8601String(),
            'dailyOrderId': formattedDailyOrderId,
            'statusHistory': {
              'status': 'pending',
              'pendingTime': Timestamp.now(),
              'ongoingTime': "",
              'confirmedTime': "",
              'cancelledTime': "",
            },
          });
        }

        await _firestore
            .collection('difwa-users')
            .doc(currentUserId)
            .update({'walletBalance': newBalance});

        await _firestore.collection('difwa-orders').doc(newBulkOrderId).set({
          'bulkOrderId': newBulkOrderId,
          'userId': currentUserId,
          'totalPrice': totalAmount,
          'totalDays': totalDays,
          'selectedDates': selectedDatesWithHistory,
          'orderData': orderData,
          'status': 'paid',
          'timestamp': FieldValue.serverTimestamp(),
          'merchantId': orderData['bottle']['merchantId'],
        });

        Get.to(() => CongratulationsPage());

        await _firestore
            .collection('difwa-order-counters')
            .doc('lastDailyOrderId')
            .update({
          'id': int.parse(
                  newDailyOrderId.split(DateTime.now().year.toString())[1]) +
              totalDays -
              1,
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
