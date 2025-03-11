class Address {
  String docId;
  final String name;
  final String street;
  final String city;
  final String state;
  final String zip;
  final bool isDeleted;
  final String country;
  final String phone;
  final bool saveAddress;
  String userId;
  final String floor;

  // Constructor with required fields
  Address({
    required this.name,
    required this.docId,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.isDeleted,
    required this.country,
    required this.phone,
    required this.saveAddress,
    required this.userId,
    required this.floor,
  });

  // Convert Address object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'phone': phone,
      'saveAddress': saveAddress,
      'isDeleted': isDeleted,
      'userId': userId,
      'docId': docId,
      'floor': floor,
    };
  }

  // Create an Address object from Firestore document
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json['name'] ?? '',
      docId: json['docId'] ?? '',
      street: json['street'] ?? '',  // Default to empty string if the field doesn't exist
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zip: json['zip'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      saveAddress: json['saveAddress'] ?? false,  // Default to false if missing
      userId: json['userId'] ?? '',  // Default to empty string if missing
      floor: json['floor'] ?? '',
    );
  }
}
