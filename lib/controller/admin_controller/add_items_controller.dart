import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> fetchMerchantId() async {
    final userIdd = _auth.currentUser?.uid;

    try {
      DocumentSnapshot storeDoc =
          await _firestore.collection('difwa-users').doc(userIdd).get();

      if (!storeDoc.exists) {
        throw Exception("Store document does not exist for this user.");
      }

      return storeDoc['merchantId'];
    } catch (e) {
      throw Exception("Failed to fetch merchantId: $e");
    }
  }

  Future<void> addBottleData(int size, double price, double vacantPrice) async {
    final userId = _auth.currentUser?.uid;
    print("User45 ID: $userId");
    String? merchantId = await fetchMerchantId();
    print("Merchant45 ID: $merchantId");

    final storeId = merchantId;

    try {
      await _firestore
          .collection('difwa-stores')
          .doc(storeId)
          .collection('difwa-items')
          .add({
        'userId': userId,
        'size': size,
        'price': price,
        'vacantPrice': vacantPrice,
        'merchantId': merchantId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to add bottle data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchBottleData() async {
    final userId = _auth.currentUser?.uid;
    print("Debug: Current user ID is $userId");

    try {
      // Fetch merchantId
      String? merchantId = await fetchMerchantId();
      print("Debug: Fetched merchant ID is $merchantId");

      if (merchantId == null) {
        throw Exception("Merchant ID is null.");
      }

      // Query all documents in difwa-items under the store (merchantId)
      QuerySnapshot snapshot = await _firestore
          .collection('difwa-stores')
          .doc(merchantId)
          .collection('difwa-items')
          // .orderBy('timestamp', descending: true)
          .get();

      print("Debug: Fetched ${snapshot.docs.length} documents from Firestore");

      // Convert documents to List<Map<String, dynamic>>
      List<Map<String, dynamic>> bottles = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        print("Debug: Document ID ${doc.id}, Data: $data");
        return data;
      }).toList();

      return bottles;
    } catch (e) {
      print("Error in fetchBottleData: $e");
      throw Exception("Failed to fetch bottle data: $e");
    }
  }

  // Update bottle data
  Future<void> updateBottleData(
      String docId, int size, double price, double vacantPrice) async {
    final userId = _auth.currentUser?.uid;
    final storeId = userId;
    try {
      String? merchantId = await fetchMerchantId();
      await _firestore
          .collection('difwa-stores')
          .doc(storeId)
          .collection('difwa-items')
          .doc(docId)
          .update({
        'size': size,
        'price': price,
        'vacantPrice': vacantPrice,
        'merchantId': merchantId,
      });
    } catch (e) {
      throw Exception("Failed to update bottle data: $e");
    }
  }

  Future<void> deleteBottleData(String docId) async {
    final userId = _auth.currentUser?.uid;
    final storeId = userId;
    try {
      await _firestore
          .collection('difwa-stores')
          .doc(storeId)
          .collection('difwa-items')
          .doc(docId)
          .delete();
    } catch (e) {
      throw Exception("Failed to delete bottle data: $e");
    }
  }
}
