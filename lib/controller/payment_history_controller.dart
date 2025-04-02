import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/models/stores_models/store_model.dart';
import 'package:difwa/models/stores_models/vendor_payment_model.dart';
import 'package:difwa/models/stores_models/withdraw_request_model.dart';
import 'package:get/get.dart';
import 'package:difwa/controller/admin_controller/add_store_controller.dart';

class PaymentHistoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AddStoreController _addStoreController = Get.put(AddStoreController());
  // final PaymentHistoryController _paymentHistoryController = Get.put(PaymentHistoryController());

  // Save payment history
  Future<void> savePaymentHistory(
      double amount,
      String amountStatus,
      String userId,
      String paymentId,
      String paymentStatus,
      String bulkOrderId) async {
    try {
      String? merchantId = await _addStoreController.fetchMerchantId();

      if (merchantId == null) {
        throw Exception("Merchant ID not found");
      }
      await _firestore.collection('difwa-vendor_payment_history').doc().set({
        'merchantId': merchantId,
        'amount': amount,
        'timestamp': FieldValue.serverTimestamp(),
        'amountStatus': amountStatus,
        'userId': userId,
        'paymentId': paymentId,
      });

      print("Payment history saved successfully.");
      Get.snackbar(
        "Success",
        "Payment history saved successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor,
      );
    } catch (e) {
      print("Error saving payment history: $e");
    }
  }

  Future<void> requestForWithdraw(double amount) async {
    try {
      print("Amountt: $amount");
      String? merchantId = await _addStoreController.fetchMerchantId();
      UserModel? storedata = await _addStoreController.fetchStoreData();

      print("storedata234");
      print("Store Data11: ${storedata?.earnings}");

      if (storedata?.earnings == null) {
        throw Exception("Earnings data is null.");
      }

      print("Earnings value before parsing: ${storedata?.earnings}");

      double? earnings = storedata?.earnings;

      print("earnings $earnings");
      // Check if earnings is valid
      if (earnings == null) {
        throw Exception("Invalid earnings value: ${storedata?.earnings}");
      }

      print("amount");
      print("earnings");
      print(amount);
      print(earnings);

      double? remainsAmount = earnings - amount;

      print("Remaininggg Amount: $remainsAmount");

      if (merchantId == null) {
        throw Exception("Merchant ID not found");
      }

      await _firestore.collection('difwa-payment-approved').doc().set({
        'merchantId': merchantId,
        'amount': amount,
        'timestamp': FieldValue.serverTimestamp(),
        'paymentStatus': "pending",
        'paymentId': "",
      });

      await _addStoreController.updateStoreDetails({"earnings": remainsAmount});

   

      await savePaymentHistory(amount, "completed", "Debited", "paymentId123",
          "success", "bulkOrderId123");

      print("Payment history saved successfully.");
      Get.snackbar(
        "Success",
        "Payment request successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor,
      );
    } catch (e) {
      print("Error saving payment history: $e");
      Get.snackbar(
        "Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor,
      );
    }
  }

Future<List<WithdrawalRequestModel>> fetchAllRequestForWithdraw() async {
  try {
    print("Starting to fetch withdrawal requests...");

    String? merchantId = await _addStoreController.fetchMerchantId();
    print("Fetched merchantId: $merchantId"); // Debugging merchantId

    if (merchantId == null) {
      throw Exception("Merchant ID not found");
    }

    QuerySnapshot snapshot = await _firestore
        .collection('difwa-payment-approved')
        .where('merchantId', isEqualTo: merchantId)
        .orderBy('timestamp', descending: true)
        .get();

    print("Fetched90 ${snapshot.docs.length} documents from Firestore."); 

    List<WithdrawalRequestModel> requests = snapshot.docs
        .map((doc) => WithdrawalRequestModel.fromFirestore(doc))
        .toList();

    print("Mapped withdrawal requests: $requests"); 

    return requests;
  } catch (e) {
    print("Error fetching withdrawal requests: $e"); 
    return [];
  }
}

  Future<List<PaymentHistoryModel>> fetchPaymentHistoryByMerchantId() async {
    try {
      String? merchantId = await _addStoreController.fetchMerchantId();

      if (merchantId == null) {
        throw Exception("Merchant ID not found");
      }

      print("Fetching payment history for merchantId: $merchantId");

      QuerySnapshot snapshot = await _firestore
          .collection('difwa-vendor_payment_history')
          .where('merchantId', isEqualTo: merchantId)
          .orderBy('timestamp', descending: true)
          .get();

      print("Fetched ${snapshot.docs.length} payment history records.");

      List<PaymentHistoryModel> paymentHistory = snapshot.docs.map((doc) {
        print("Processing document with ID: ${doc.id}");
        return PaymentHistoryModel.fromFirestore(
            doc.data() as Map<String, dynamic>);
      }).toList();

      print("Payment history processed successfully.");
      return paymentHistory;
    } catch (e) {
      print("Error fetching payment history by merchantId: $e");
      return [];
    }
  }
}
