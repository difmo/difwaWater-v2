import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/admin_controller/vendors_controller.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  VendorsController _vendorsController = Get.put(VendorsController());
  var verificationId = ''.obs;
  var userRole = ''.obs;

  Future<Map<String, int>> fetchTotalTodayOrders() async {
    String? merchantId = await _vendorsController.fetchMerchantId();

    DateTime today = DateTime.now();
    String todayStr =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    QuerySnapshot userDoc = await _firestore
        .collection('difwa-orders')
        .where('merchantId', isEqualTo: merchantId)
        .get();

    print(userDoc.docs.length);
    int todayPendingOrders = 0;
    int todayTotalOrders = 0;
    int todayTotalCompletedOrder = 0;
    int todayPreparingOrders = 0;
    int todayShippedOrders = 0;
    int overallTotalOrders = 0;
    int overallPendingOrders = 0;
    int overallCompletedOrders = 0;

    for (var doc in userDoc.docs) {
      var selectedDates = doc['selectedDates'];

      if (selectedDates != null) {
        for (var selectedDate in selectedDates) {
          var statusHistory = selectedDate['statusHistory'];
          if (statusHistory != null) {
            String orderDate = selectedDate['date'].toString().split("T")[0];

            overallTotalOrders++;

            if (statusHistory['status'] == 'pending') {
              overallPendingOrders++;
            }
            if (statusHistory['status'] == 'Completed') {
              overallCompletedOrders++;
            }
            if (statusHistory['status'] == 'Preparing') {}
            if (statusHistory['status'] == 'Shipped') {}
            if (orderDate == todayStr) {
              todayTotalOrders++;

              if (statusHistory['status'] != 'Completed') {
                todayPendingOrders++;
              }
              if (statusHistory['status'] == 'Completed') {
                todayTotalCompletedOrder++;
              }
              if (statusHistory['status'] == 'Preparing') {
                todayPreparingOrders++;
              }
              if (statusHistory['status'] == 'Shipped') {
                todayShippedOrders++;
              }
            }
          }
        }
      }
    }

    return {
      'totalOrders': todayTotalOrders,
      'pendingOrders': todayPendingOrders,
      'completedOrders': todayTotalCompletedOrder,
      'preparingOrders': todayPreparingOrders,
      'shippedOrders': todayShippedOrders,
      'overallTotalOrders': overallTotalOrders,
      'overallPendingOrders': overallPendingOrders,
      'overallCompletedOrders': overallCompletedOrders,
    };
  }
}
