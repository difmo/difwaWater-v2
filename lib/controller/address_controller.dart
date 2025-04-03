import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Address> addressList = <Address>[].obs;

  void selectAddress(String docId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print("User not logged in!");
        return;
      }

      // Get the reference to the user's address collection
      CollectionReference addressCollection = FirebaseFirestore.instance
          .collection('difwa-users')
          .doc(user.uid)
          .collection('User-address');

      // First, find the address that is currently selected
      QuerySnapshot selectedAddressSnapshot = await addressCollection
          .where('isSelected', isEqualTo: true)
          .limit(1) // Limit to 1 result, as only one address can be selected
          .get();

      if (selectedAddressSnapshot.docs.isNotEmpty) {
        // If there's an address already selected, update it to set isSelected = false
        DocumentSnapshot selectedAddressDoc =
            selectedAddressSnapshot.docs.first;
        await selectedAddressDoc.reference.update({
          'isSelected': false,
        });
        print("Previously selected address deselected.");
      }

      // Now, update the selected address to true
      DocumentReference addressDocRef = addressCollection.doc(docId);
      DocumentSnapshot addressDocSnapshot = await addressDocRef.get();

      if (addressDocSnapshot.exists) {
        await addressDocRef.update({
          'isSelected': true,
        });
        print("Address selection updated successfully!");
      } else {
        print("Address not found!");
      }
    } catch (e) {
      print("Error toggling address selection: $e");
    }
  }

  Future<bool> saveAddress(Address address) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        address.userId = user.uid;

        DocumentReference docRef = _firestore
            .collection('difwa-users')
            .doc(user.uid)
            .collection('User-address')
            .doc();
        address.docId = docRef.id;
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

  Stream<List<Address>> getAddresses() {
    final user = _auth.currentUser;

    if (user != null) {
      return _firestore
          .collection('difwa-users')
          .doc(user.uid)
          .collection('User-address')
          .where('isDeleted', isEqualTo: false)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Address.fromJson(doc.data());
        }).toList();
      });
    } else {
      return Stream.value([]);
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      print("delete0");
      final user = _auth.currentUser;
      if (user != null) {
        print("delete");
        await _firestore
            .collection('difwa-users')
            .doc(user.uid)
            .collection('User-address')
            .doc(addressId)
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

  Future<void> updateAddress(Address address) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        await _firestore
            .collection('difwa-users')
            .doc(user.uid)
            .collection('User-address')
            .doc(address.docId)
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
//  fdklfjdkfjlsd