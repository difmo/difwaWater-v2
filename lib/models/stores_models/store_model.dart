class UserModel {
  final String userId;
  final String upiId;
  final String mobile;
  final String email;
  final String shopName;
  final String ownerName;
  final String merchantId;
  final String earnings;
  final String uid;
  final String? imageUrl;
  final String? storeaddress;

  UserModel({
    required this.userId,
    required this.upiId,
    required this.mobile,
    required this.email,
    required this.shopName,
    required this.ownerName,
    required this.merchantId,
    required this.earnings,

    required this.uid,
    required this.imageUrl,
    required this.storeaddress,
  });

  // Convert a Map from Firestore to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      upiId: map['upiId'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      shopName: map['shopName'] ?? '',
      ownerName: map['ownerName'] ?? '',
      merchantId: map['merchantId'] ?? '',
      earnings: map['earnings'] ?? '',
      uid: map['uid'] ?? '',
      imageUrl: map['imageUrl'], // Optional, can be null
      storeaddress: map['storeaddress'], // Optional, can be null
    );
  }

  // Convert the UserModel to a Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'upiId': upiId,
      'mobile': mobile,
      'email': email,
      'shopName': shopName,
      'ownerName': ownerName,
      'merchantId': merchantId,
      'earnings': earnings,
      'uid': uid,
      'imageUrl': imageUrl,
      'storeaddress': storeaddress,
    };
  }
}
