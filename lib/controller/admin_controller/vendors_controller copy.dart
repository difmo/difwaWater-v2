// import 'dart:io';
// import 'package:difwa/controller/admin_controller/add_items_controller.dart';
// import 'package:difwa/models/stores_models/store_new_modal.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class VendorsController extends GetxController {
//   final _formKey = GlobalKey<FormState>();

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   File? imageFile;
//   final FirebaseController _authController = Get.put(FirebaseController());
//   @override
//   Future<void> checkFunction() async {
//     String merchantId = await _generateMerchantId();
//     print("generated merchant id ");
//     print(merchantId);
//     return;
//   }

//   Future<String> uploadImage(File imageFile, String fileName) async {
//     try {
//       Reference ref = _storage.ref().child('vendor_images/$fileName');

//       await ref.putFile(imageFile);

//       String imageUrl = await ref.getDownloadURL();

//       // Debugging snackbar
//       Get.snackbar(
//         'Upload Success',
//         'Image uploaded successfully: $fileName',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );

//       return imageUrl;
//     } catch (e) {
//       print("Error uploading image: $e");

//       // Error snackbar
//       Get.snackbar(
//         'Upload Error',
//         'Failed to upload image: $fileName',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );

//       rethrow;
//     }
//   }

//   Future<bool> submitForm2(
//       Map<String, String> images, VendorModal? newUser) async {
//     try {
//       String userId = await _getCurrentUserId();
//       String merchantId = await _generateMerchantId();

//       if (newUser != null) {
//         newUser = newUser.copyWith(
//           userId: userId,
//           merchantId: merchantId,
//         );
//       }
//       if (newUser != null) {
//         print("here i am 1");
//         await _saveUserStore(newUser, merchantId);
//         print("here i am 2");
//       } else {
//         throw Exception('VendorModal cannot be null');
//       }
//       await _updateUserRole(userId, merchantId);
//       _showSuccessSnackbar(merchantId);
//       return true;
//     } catch (e) {
//       print("hamar error");
//       print(e);
//       _handleError(e);
//       return false;
//     }
//   }

//   Future<void> editVendorDetails({VendorModal? modal}) async {
//     try {
//       if (modal == null) {
//         throw Exception("Vendor modal is null.");
//       }

//       String userId = await _getCurrentUserId();
//       String? merchantId = await fetchMerchantId();
//       if (merchantId == null) {
//         throw Exception("Merchant ID not found for user: $userId");
//       }

//       // Prepare the data to update, excluding null fields
//       Map<String, dynamic> updateData = modal.toMap();
//       updateData.removeWhere((key, value) => value == null);

//       // Update Firestore document
//       await FirebaseFirestore.instance
//           .collection('difwa-stores')
//           .doc(userId)
//           .set(updateData,
//               SetOptions(merge: true)); // Use merge for partial updates

//       Get.snackbar(
//         'Success',
//         'Vendor details updated successfully!',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("Edit vendor error: $e");
//       Get.snackbar(
//         'Error',
//         'Failed to edit vendor: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       rethrow; // Rethrow for debugging purposes
//     }
//   }

//   var storeStatus = false.obs; // Observable boolean
//   var balance = 0.0.obs; // Observable double
//   var vendorName = "".obs; // Observable double

//   void fetchStoreDataRealTime(String merchantId) {
//     FirebaseFirestore.instance
//         .collection('difwa-stores')
//         .where('merchantId', isEqualTo: merchantId)
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         final storeDoc = snapshot.docs.first;
//         storeStatus.value = storeDoc['isActive'] ?? false;
//         balance.value = storeDoc['earnings'] ?? 0.0;
//         vendorName.value = storeDoc['vendorName'] ?? "No name";
//       }
//     });
//   }

//   Future<VendorModal?> fetchStoreData() async {
//     String? merchantId = await _authController.fetchMerchantId("");
//     if (merchantId == null) {
//       return null;
//     }
//     print("fetch store data2");

//     try {
//       QuerySnapshot storeQuerySnapshot = await FirebaseFirestore.instance
//           .collection('difwa-stores')
//           .where('merchantId', isEqualTo: merchantId)
//           .get();

//       if (storeQuerySnapshot.docs.isNotEmpty) {
//         DocumentSnapshot storeDoc = storeQuerySnapshot.docs.first;

//         VendorModal storeData =
//             VendorModal.fromMap(storeDoc.data() as Map<String, dynamic>);

//         return storeData;
//       } else {
//         throw Exception('Store with Merchant ID $merchantId not found');
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to fetch store data: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return null;
//     }
//   }

//   Future<String> _getCurrentUserId() async {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       throw Exception('User not authenticated');
//     }
//     return currentUser.uid;
//   }

//   Future<String> _generateMerchantId() async {
//     String year = DateTime.now().year.toString().substring(2);

//     try {
//       DocumentReference counterDoc = FirebaseFirestore.instance
//           .collection('difwa-order-counters')
//           .doc('merchantIdCounter');

//       String newMerchantId =
//           await FirebaseFirestore.instance.runTransaction((transaction) async {
//         DocumentSnapshot counterSnapshot = await transaction.get(counterDoc);

//         if (!counterSnapshot.exists) {
//           transaction.set(counterDoc, {'count': 0});
//         }
//         int userCount = counterSnapshot.exists ? counterSnapshot['count'] : 0;
//         String merchantId =
//             'DW$year${(userCount + 1).toString().padLeft(7, '0')}';

//         // Increment the count
//         transaction.update(counterDoc, {'count': userCount + 1});

//         return merchantId;
//       });

//       return newMerchantId;
//     } catch (e) {
//       throw Exception('Error generating merchant ID: ${e.toString()}');
//     }
//   }

//   void setImage(File image) {
//     imageFile = image;
//   }

//   Future<bool> getIsActiveStore(String merchantId) async {
//     try {
//       QuerySnapshot storeQuerySnapshot = await FirebaseFirestore.instance
//           .collection('difwa-stores')
//           .where('merchantId', isEqualTo: merchantId)
//           .get();

//       if (storeQuerySnapshot.docs.isNotEmpty) {
//         DocumentSnapshot storeDoc = storeQuerySnapshot.docs.first;

//         bool isActive = storeDoc['isActive'] ?? false;
//         return isActive;
//       } else {
//         throw Exception('Store with Merchant ID $merchantId not found');
//       }
//     } catch (e) {
//       // Handle any errors
//       Get.snackbar(
//         'Error',
//         'Failed to fetch store status: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return false; // Return false if there's an error
//     }
//   }

//   Future<void> toggleStoreActiveStatusByCurrentUser() async {
//     try {
//       User? currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser == null) {
//         throw Exception('User not authenticated');
//       }
//       String userId = currentUser.uid;

//       DocumentSnapshot storeDoc = await FirebaseFirestore.instance
//           .collection('difwa-stores')
//           .doc(
//               userId) // Use the current user's UID as the document ID (merchantId)
//           .get();

//       if (storeDoc.exists) {
//         bool currentStatus = storeDoc['isActive'] ?? false;

//         bool newStatus = !currentStatus;

//         await FirebaseFirestore.instance
//             .collection('difwa-stores')
//             .doc(userId) // Use the userId (merchantId) as the document ID
//             .update({'isActive': newStatus});

//         // Show success message
//         Get.snackbar(
//           'Success',
//           'Store active status updated to: $newStatus',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         throw Exception('Store with Merchant ID $userId not found');
//       }
//     } catch (e) {
//       // Handle any errors
//       Get.snackbar(
//         'Error',
//         'Failed to toggle store status: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> _updateUserRole(String userId, String merchantId) async {
//     String? merchantId = await _authController.fetchMerchantId("");
//     if (merchantId == null) {
//       print("Merchant ID is null");
//       return;
//     }

//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('difwa-users')
//         .doc(userId)
//         .get();

//     if (userDoc.exists) {
//       await FirebaseFirestore.instance
//           .collection('difwa-users')
//           .doc(userId)
//           .update({
//         'role': 'isStoreKeeper',
//         'merchantId': merchantId,
//         'isActive': false
//       });
//     } else {
//       await FirebaseFirestore.instance
//           .collection('difwa-users')
//           .doc(userId)
//           .set({
//         'role': 'isStoreKeeper',
//         'userId': userId,
//       }, SetOptions(merge: true));
//     }
//   }

//   Future<void> _saveUserStore(VendorModal newUser, String newmerchantId) async {
//     print("here i am 3");
//     await FirebaseFirestore.instance
//         .collection('difwa-stores')
//         .doc()
//         .set(newUser.toMap());
//     print("here i am 4");
//   }

//   void _showSuccessSnackbar(String merchantId) {
//     Get.snackbar(
//       'Success',
//       'Signup Successful with Merchant ID: $merchantId',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   }

//   void _handleError(dynamic e) {
//     print("error test");
//     print(e);
//     String errorMessage = e is FirebaseAuthException
//         ? e.message ?? 'An unknown sdfsdf error occurred'
//         : 'An unknown error occurred';
//     Get.snackbar('Error', errorMessage,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white);
//   }

//   Future<String?> fetchMerchantId() async {
//     final userIdd = _auth.currentUser?.uid;

//     try {
//       DocumentSnapshot storeDoc =
//           await _firestore.collection('difwa-stores').doc(userIdd).get();

//       if (!storeDoc.exists) {
//         throw Exception("Store document does not exist for this user.");
//       }

//       return storeDoc['merchantId'];
//     } catch (e) {
//       throw Exception("Failed to fetch merchantId: $e");
//     }
//   }

//   Future<void> deleteStore() async {
//     try {
//       String userId = await _getCurrentUserId();
//       await FirebaseFirestore.instance
//           .collection('difwa-stores')
//           .doc(userId)
//           .delete();
//       Get.snackbar('Success', 'Store deleted successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white);
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to delete store: ${e.toString()}',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     }
//   }

//   Future<void> updateStoreDetails(Map<String, dynamic> updates) async {
//     try {
//       String userId = await _getCurrentUserId();
//       await FirebaseFirestore.instance
//           .collection('difwa-stores')
//           .doc(userId)
//           .update(updates);
//       Get.snackbar('Success', 'Store details updated successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white);
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update store: ${e.toString()}',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     }
//   }

//   GlobalKey<FormState> get formKey => _formKey;
// }
