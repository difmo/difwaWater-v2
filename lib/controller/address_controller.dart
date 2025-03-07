import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to save the address.
  Future<void> saveAddress(
    String street,
    String city,
    String state,
    String zip,
    String country,
    String phone,
    bool isChecked,
  ) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        await _firestore
            .collection('difwa-users')
            .doc(user
                .uid) // Use user ID to save the address under the specific user
            .collection('User-address') // Subcollection for address data
            .doc() // Can use 'address' or any unique ID if needed
            .set({
          'street': street,
          'city': city,
          'state': state,
          'zip': zip,
          'country': country,
          'phone': phone,
          'saveAddress': isChecked,
          'userId': user.uid,
        }, SetOptions(merge: true));

        Get.snackbar('Success', 'Address saved successfully!');
      } else {
        Get.snackbar('Error', 'User not logged in.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save the address: $e');
    }
  }

  // Fetch the data address.
  Future<Map<String, dynamic>?> getAddress() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot addressDoc = await _firestore
            .collection('difwa-user') // Collection for user data
            .doc() // Use user ID to fetch the address for the specific user
            .collection('User-address') // Subcollection for address data
            .doc('address') // Assuming only one address for each user
            .get();

        if (addressDoc.exists) {
          return addressDoc.data() as Map<String, dynamic>;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch address: $e');
      return null;
    }
  }
}
