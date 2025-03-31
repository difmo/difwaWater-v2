// import 'dart:io';
// import 'package:difwa/models/stores_models/store_model.dart';
// // import 'package:difwa/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class AddStoreController extends GetxController {
//   final _formKey = GlobalKey<FormState>();
//   final upiIdController = TextEditingController();
//   final emailController = TextEditingController();
//   final mobileController = TextEditingController();
//   final ownernameController = TextEditingController();
//   final shopnameController = TextEditingController();
//   final storeaddressController = TextEditingController();
//   File? imageFile;

//   @override
//   void onClose() {
//     upiIdController.dispose();
//     emailController.dispose();
//     mobileController.dispose();
//     ownernameController.dispose();
//     shopnameController.dispose();
//     storeaddressController.dispose();
//     super.onClose();
//   }

//   Future<void> checkFunction() async {
//     String merchantId = await _generateMerchantId();
//     print("generated merchant id ");
//     print(merchantId);
//     return;
//   }

//   Future<bool> submitForm(File? image) async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         String userId = await _getCurrentUserId();
//         String merchantId = await _generateMerchantId();

//         String? imageUrl;
//         if (imageFile != null) {
//           imageUrl = await _uploadImage(imageFile!, userId);
//         }

//         UserModel newUser = _createUserModel(userId, merchantId, imageUrl);

//         await _updateUserRole(userId, merchantId);
//         await _saveUserStore(newUser);

//         _showSuccessSnackbar(merchantId);
//         // Get.offAllNamed(AppRoutes.storebottombar);

//         return true;
//       } catch (e) {
//         _handleError(e);
//         return false;
//       }
//     } else {
//       return false;
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
//           await transaction.set(counterDoc, {'count': 0});
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

//   Future<String> _uploadImage(File imageFile, String userId) async {
//     try {
//       final storageRef = FirebaseStorage.instance.ref().child(
//           'user_images/$userId/${DateTime.now().millisecondsSinceEpoch}');
//       await storageRef.putFile(imageFile);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       throw Exception('Failed to upload image: ${e.toString()}');
//     }
//   }

//   UserModel _createUserModel(
//       String userId, String merchantId, String? imageUrl) {
//     return UserModel(
//       userId: userId,
//       upiId: upiIdController.text,
//       mobile: mobileController.text,
//       email: emailController.text,
//       shopName: shopnameController.text,
//       ownerName: ownernameController.text,
//       merchantId: merchantId,
//       uid: userId,
//       storeaddress: storeaddressController.text,
//       imageUrl: imageUrl,
//     );
//   }

//   void setImage(File image) {
//     imageFile = image;
//   }

// Future<bool> getIsActiveStore(String merchantId) async {
//   try {

//     QuerySnapshot storeQuerySnapshot = await FirebaseFirestore.instance
//         .collection('difwa-stores')
//         .where('merchantId', isEqualTo: merchantId) 
//         .get();

//     if (storeQuerySnapshot.docs.isNotEmpty) {
//       DocumentSnapshot storeDoc = storeQuerySnapshot.docs.first;

//       bool isActive = storeDoc['isActive'] ?? false; // Default to false if not found
//       return isActive;
//     } else {
//       throw Exception('Store with Merchant ID $merchantId not found');
//     }
//   } catch (e) {
//     // Handle any errors
//     Get.snackbar(
//       'Error',
//       'Failed to fetch store status: ${e.toString()}',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//     return false; // Return false if there's an error
//   }
// }


// Future<void> toggleStoreActiveStatusByCurrentUser() async {

//   try {

//     // Step 1: Get the current user's ID
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       throw Exception('User not authenticated');
//     }
//     String userId = currentUser.uid; 

//     DocumentSnapshot storeDoc = await FirebaseFirestore.instance
//         .collection('difwa-stores')
//         .doc(userId) // Use the current user's UID as the document ID (merchantId)
//         .get();

//     if (storeDoc.exists) {
//       bool currentStatus = storeDoc['isActive'] ?? false;

//       bool newStatus = !currentStatus;

//       await FirebaseFirestore.instance
//           .collection('difwa-stores')
//           .doc(userId) // Use the userId (merchantId) as the document ID
//           .update({'isActive': newStatus});
      
//       // Show success message
//       Get.snackbar(
//         'Success',
//         'Store active status updated to: $newStatus',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } else {
//       throw Exception('Store with Merchant ID $userId not found');
//     }
//   } catch (e) {
//     // Handle any errors
//     Get.snackbar(
//       'Error',
//       'Failed to toggle store status: ${e.toString()}',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
// }


//   Future<void> _updateUserRole(String userId, String merchantId) async {
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('difwa-users')
//         .doc(userId)
//         .get();

//     if (userDoc.exists) {
//       await FirebaseFirestore.instance
//           .collection('difwa-users')
//           .doc(userId)
//           .update({'role': 'isStoreKeeper', 'merchantId': merchantId,'isActive':false});
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

//   Future<void> _saveUserStore(UserModel newUser) async {
//     await FirebaseFirestore.instance
//         .collection('difwa-stores')
//         .doc(newUser.uid)
//         .set(newUser.toMap());
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
//     String errorMessage = e is FirebaseAuthException
//         ? e.message ?? 'An unknown error occurred'
//         : 'An unknown error occurred';
//     Get.snackbar('Error', errorMessage,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white);
//   }

//   GlobalKey<FormState> get formKey => _formKey;
// }
