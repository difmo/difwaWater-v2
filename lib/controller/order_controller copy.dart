import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/admin_controller/vendors_controller.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  VendorsController _vendorsController = Get.put(VendorsController());
  var verificationId = ''.obs;
  var userRole = ''.obs;

  Future<int> fetchVendorAllCompletedBulkdOrder() async {
    String? merchantId = "";
    int storeTotalNumberOfBulkOrderPending1 = 0;

    merchantId = await _vendorsController.fetchMerchantId();

    QuerySnapshot userDoc = await _firestore
        .collection('difwa-orders')
        .where('merchantId', isEqualTo: merchantId)
        .get();

    if (userDoc.docs.isNotEmpty) {
      for (var doc in userDoc.docs) {
        print("doc['status'] : ${doc['status']}");
        print("doc['merchantId'] : ${doc['merchantId']}");
        if (doc['status'] == "confirmed") {
          storeTotalNumberOfBulkOrderPending1++;
        }
      }
    }

    print(
        "storeTotalNumberOfBulkOrderPending1 : $storeTotalNumberOfBulkOrderPending1");
    print("merchantId : $merchantId");

    // Return the count
    return storeTotalNumberOfBulkOrderPending1;
  }

  Future<int> fetchStoreTotalNumberOfBulkOrderPending() async {
    String? merchantId = "";
    int storeTotalNumberOfBulkOrderPending = 0;

    merchantId = await _vendorsController.fetchMerchantId();

    QuerySnapshot userDoc = await _firestore
        .collection('difwa-orders')
        .where('merchantId', isEqualTo: merchantId)
        .get();

    if (userDoc.docs.isNotEmpty) {
      for (var doc in userDoc.docs) {
        print("doc['status'] : ${doc['status']}");
        print("doc['merchantId'] : ${doc['merchantId']}");
        if (doc['status'] == "pending" || doc['status'] == "paid") {
          storeTotalNumberOfBulkOrderPending++;
        }
      }
    }

    print(
        "storeTotalNumberOfBulkOrderPending : $storeTotalNumberOfBulkOrderPending");
    print("merchantId : $merchantId");

    // Return the count
    return storeTotalNumberOfBulkOrderPending;
  }

  Future<Map<String, int>> fetchOrdersStatusAndDates() async {
    String? merchantId = await _vendorsController.fetchMerchantId();

    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(Duration(days: 1));

    String todayStr =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    String tomorrowStr =
        "${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}";

    QuerySnapshot userDoc = await _firestore
        .collection('difwa-orders')
        .where('merchantId', isEqualTo: merchantId)
        .get();

    int pendingOrders = 0;
    int todayOrders = 0;
    int tomorrowOrders = 0;

    for (var doc in userDoc.docs) {
      var selectedDates = doc['selectedDates'];

      if (selectedDates != null) {
        for (var selectedDate in selectedDates) {
          var statusHistory = selectedDate['statusHistory'];
          if (statusHistory != null) {
            if (statusHistory['status'] == 'pending') {
              pendingOrders++;
            }

            String orderDate = selectedDate['date']
                .toString()
                .split("T")[0];
            if (orderDate == todayStr) {
              todayOrders++;
            } else if (orderDate == tomorrowStr) {
              tomorrowOrders++;
            }
          }
        }
      }
    }

    print("Pending Orders: $pendingOrders");
    print("Today's Orders: $todayOrders");
    print("Tomorrow's Orders: $tomorrowOrders");

    // Return the counts of pending, today's, and tomorrow's orders
    return {
      'pendingOrders': pendingOrders,
      'todayOrders': todayOrders,
      'tomorrowOrders': tomorrowOrders,
    };
  }

Future<Map<String, dynamic>> fetchOrdersStatusAndDates3() async {
  String? merchantId = await _vendorsController.fetchMerchantId();

  DateTime today = DateTime.now();
  DateTime tomorrow = today.add(Duration(days: 1));

  String todayStr =
      "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
  String tomorrowStr =
      "${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}";

  // Fetch all orders for the given merchant
  QuerySnapshot userDoc = await _firestore
      .collection('difwa-orders')
      .where('merchantId', isEqualTo: merchantId)
      .get();

  int pendingOrders = 0;
  int todayOrders = 0;
  int tomorrowOrders = 0;

  List<Map<String, dynamic>> dailyPendingOrders = [];

  for (var doc in userDoc.docs) {
    var selectedDates = doc['selectedDates'];

    if (selectedDates != null) {
      for (var selectedDate in selectedDates) {
        var statusHistory = selectedDate['statusHistory'];
        if (statusHistory != null) {
          // Track pending orders
          if (statusHistory['status'] == 'pending') {
            pendingOrders++;

            // Add the daily pending order for this particular date
            dailyPendingOrders.add({
              'orderId': doc['bulkOrderId'], // Assuming 'bulkOrderId' is the order identifier
              'date': selectedDate['date'],
              'status': statusHistory['status'],
            });
          }

          // Check for today's and tomorrow's orders
          String orderDate = selectedDate['date'].toString().split("T")[0]; // Extract date part (yyyy-MM-dd)
          if (orderDate == todayStr) {
            todayOrders++;
          } else if (orderDate == tomorrowStr) {
            tomorrowOrders++;
          }
        }
      }
    }
  }

  // Print the results
  print("Pending Orders: $pendingOrders");
  print("Today's Orders: $todayOrders");
  print("Tomorrow's Orders: $tomorrowOrders");
  print("Daily Pending Orders: ${dailyPendingOrders.length}");


  // Return the counts and the daily pending orders list
  return {
    'pendingOrders': pendingOrders,
    'todayOrders': todayOrders,
    'tomorrowOrders': tomorrowOrders,
    'dailyPendingOrders': dailyPendingOrders,
  };
}

Future<int> fetchTotalTodayPendingOrders() async {
  String? merchantId = await _vendorsController.fetchMerchantId();

  // Get today's date in proper format
  DateTime today = DateTime.now();
  String todayStr =
      "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

  // Fetch all orders for the given merchant
  QuerySnapshot userDoc = await _firestore
      .collection('difwa-orders')
      .where('merchantId', isEqualTo: merchantId)
      .get();

  int todayPendingOrders = 0;

  // Iterate through all the orders for the merchant
  for (var doc in userDoc.docs) {
    var selectedDates = doc['selectedDates'];

    if (selectedDates != null) {
      for (var selectedDate in selectedDates) {
        var statusHistory = selectedDate['statusHistory'];
        if (statusHistory != null) {
          // Check if the status is pending
          if (statusHistory['status'] != 'Completed') {
            // Extract the order date and compare with today's date
            String orderDate = selectedDate['date'].toString().split("T")[0]; // Extract date part (yyyy-MM-dd)
            if (orderDate == todayStr) {
              todayPendingOrders++; // Increment count if it's today's pending order
            }
          }
        }
      }
    }
  }

  // Print the result
  print("Total Today's Pending Orders: $todayPendingOrders");

  // Return the count of today's pending orders
  return todayPendingOrders;
}

  
}
