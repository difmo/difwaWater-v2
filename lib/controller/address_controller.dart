import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/address_model.dart';

class AddressController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to save the address.
  Future<void> saveAddress(Address address) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        address.userId = user.uid;

        // Save address to Firestore
        await _firestore
            .collection('difwa-users') // User-specific collection
            .doc(user.uid) // User document
            .collection('User-address') // Subcollection for addresses
            .doc() // Creates a new document with a random ID
            .set(address.toJson(), SetOptions(merge: true));

        Get.snackbar('Success', 'Address saved successfully!');
      } else {
        Get.snackbar('Error', 'User not logged in.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save the address: $e');
    }
  }

  // Fetch the user's addresses.
  Future<List<Address>> getAddresses() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Fetch all addresses for the current user
        QuerySnapshot querySnapshot = await _firestore
            .collection('difwa-users') // User-specific collection
            .doc(user.uid) // User document
            .collection('User-address') // Subcollection for addresses
            .get();

        // Check if the user has any addresses
        if (querySnapshot.docs.isNotEmpty) {
          // Map the Firestore documents to Address objects
          return querySnapshot.docs.map((doc) {
            return Address.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();
        } else {
          return []; // Return an empty list if no addresses found
        }
      } else {
        return []; // Return an empty list if no user is logged in
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch addresses: $e');
      return []; // Return an empty list on error
    }
  }

  // Method to delete an address
  Future<void> deleteAddress(String addressId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete the address from Firestore using the document ID
        await _firestore
            .collection('difwa-users') // User-specific collection
            .doc(user.uid) // User document
            .collection('User-address') // Subcollection for addresses
            .doc(addressId) // Document ID to delete
            .delete();

        Get.snackbar('Success', 'Address deleted successfully!');
      } else {
        Get.snackbar('Error', 'User not logged in.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete the address: $e');
    }
  }

  // Method to update an existing address
  Future<void> updateAddress(String addressId, Address address) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        // Update the address document in Firestore using the addressId
        await _firestore
            .collection('difwa-users') // User-specific collection
            .doc(user.uid) // User document
            .collection('User-address') // Subcollection for addresses
            .doc(addressId) // Document ID to update
            .update(address.toJson());

        Get.snackbar('Success', 'Address updated successfully!');
      } else {
        Get.snackbar('Error', 'User not logged in.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update the address: $e');
    }
  }
}
