import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/address_model.dart';

class AddressController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to save the address.
  Future<bool> saveAddress(Address address) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        address.userId = user.uid;

        // Save address to Firestore
        DocumentReference docRef = _firestore
            .collection('difwa-users') // User-specific collection
            .doc(user.uid) // User document
            .collection('User-address') // Subcollection for addresses
            .doc(); // Creates a new document with a random ID

        address.docId = docRef.id; // Set the document ID in the address object

        await docRef.set(address.toJson(), SetOptions(merge: true));

        Get.snackbar('Success', 'Address saved successfully!');
        return true;
      } else {
        Get.snackbar('Error', 'User not logged in.');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save the address: $e');
      return false;
    }
  }

  // Fetch the user's addresses in real-time.
  Stream<List<Address>> getAddresses() {
    final user = _auth.currentUser;

    if (user != null) {
      // Fetch all addresses for the current user
      return _firestore
          .collection('difwa-users') // User-specific collection
          .doc(user.uid) // User document
          .collection('User-address') // Subcollection for addresses
          .where('isDeleted', isEqualTo: false)
          .snapshots() // Use snapshots() for real-time updates
          .map((querySnapshot) {
        // Map the Firestore documents to Address objects
        return querySnapshot.docs.map((doc) {
          return Address.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } else {
      // If no user is logged in, return an empty list
      return Stream.value([]);
    }
  }

  // Method to delete an address
  Future<void> deleteAddress(String addressId) async {
    try {
      print("delete0");
      final user = _auth.currentUser;
      if (user != null) {
        print("delete");
        // Delete the address from Firestore using the document ID
        await _firestore
            .collection('difwa-users') // User-specific collection
            .doc(user.uid) // User document
            .collection('User-address') // Subcollection for addresses
            .doc(addressId) // Document ID to delete
            .delete();

        Get.snackbar('Success', 'Address deleted successfully!');
      } else {
        print("delete1");
        Get.snackbar('Error', 'User not logged in.');
      }
    } catch (e) {
      print("delete2");
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
