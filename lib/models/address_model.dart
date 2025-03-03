class Address {
  final String name;
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;
  final String phone;
  final bool saveAddress;
  String userId;

  // Constructor with required fields
  Address({
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.phone,
    required this.saveAddress,
    required this.userId,
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
      'userId': userId,
    };
  }

  // Create an Address object from Firestore document
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json['name'] ??'',
      street: json['street'] ?? '',  // Default to empty string if the field doesn't exist
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zip: json['zip'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'] ?? '',
      saveAddress: json['saveAddress'] ?? false,  // Default to false if missing
      userId: json['userId'] ?? '',  // Default to empty string if missing
    );
  }
}
