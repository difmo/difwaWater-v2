import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/admin_controller/add_items_controller.dart';
import 'package:difwa/controller/admin_controller/add_store_controller.dart';
import 'package:get/get.dart';

class EarningController extends GetxController {
  final FirebaseController _authController = Get.put(FirebaseController());
  final AddStoreController _addstoreController = Get.put(AddStoreController());
  Future<Map<String, int>> fetchEarnings() async {
    try {
      String? merchantId = await _authController.fetchMerchantId("");
      if (merchantId == null) {
        print("Merchant ID is null");
        return {};
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("difwa-orders")
          .where('merchantId', isEqualTo: merchantId)
          .where('status', isEqualTo: 'confirmed')
          .get();

      DateTime now = DateTime.now();
      DateTime todayStart = DateTime(now.year, now.month, now.day);
      DateTime yesterdayStart = todayStart.subtract(Duration(days: 1));
      DateTime weekStart = todayStart.subtract(Duration(days: 7));
      DateTime monthStart = DateTime(now.year, now.month, 1);

      double todayEarnings = 0.0;
      double yesterdayEarnings = 0.0;
      double weeklyEarnings = 0.0;
      double monthlyEarnings = 0.0;
      double totalEarnings = 0.0;

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        Timestamp orderTimestamp = data['timestamp'];
        DateTime orderDate = orderTimestamp.toDate();
        double totalPrice = (data['totalPrice'] ?? 0.0).toDouble();

        totalEarnings += totalPrice; // Accumulate total earnings

        if (orderDate.isAfter(todayStart)) {
          todayEarnings += totalPrice;
        }
        if (orderDate.isAfter(yesterdayStart) &&
            orderDate.isBefore(todayStart)) {
          yesterdayEarnings += totalPrice;
        }
        if (orderDate.isAfter(weekStart)) {
          weeklyEarnings += totalPrice;
        }
        if (orderDate.isAfter(monthStart)) {
          monthlyEarnings += totalPrice;
        }
      }

      await _addstoreController
          .updateStoreDetails({"earnings": totalEarnings.toInt()});

      return {
        "today": todayEarnings.toInt(),
        "yesterday": yesterdayEarnings.toInt(),
        "weekly": weeklyEarnings.toInt(),
        "monthly": monthlyEarnings.toInt(),
        "total": totalEarnings.toInt(),
      };
    } catch (e) {
      print("Error fetching earnings: $e");
      return {};
    }
  }

  Future<int> fetchEarningsByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      String? merchantId = await _authController.fetchMerchantId("");
      if (merchantId == null) {
        print("Merchant ID is null");
        return 0;
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("difwa-orders")
          .where('merchantId', isEqualTo: merchantId)
          .where('status', isEqualTo: 'confirmed')
          .get();

      double totalEarnings = querySnapshot.docs.fold(0.0, (sum, doc) {
        var data = doc.data() as Map<String, dynamic>;
        Timestamp orderTimestamp = data['timestamp'];
        DateTime orderDate = orderTimestamp.toDate();
        double totalPrice = (data['totalPrice'] ?? 0.0).toDouble();

        if (orderDate.isAfter(startDate) && orderDate.isBefore(endDate)) {
          return sum + totalPrice;
        }
        return sum;
      });

      return totalEarnings.toInt();
    } catch (e) {
      print("Error fetching earnings by date range: $e");
      return 0;
    }
  }
}
