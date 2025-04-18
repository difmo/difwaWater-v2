class VendorModal {
  String userId;
  String merchantId;
  final double earnings;
  String vendorName;
  String bussinessName;
  String contactPerson;
  String phoneNumber;
  String email;
  String vendorType;
  String businessAddress;
  String areaCity;
  String postalCode;
  String state;
  String waterType;
  String capacityOptions;
  String dailySupply;
  String deliveryArea;
  String deliveryTimings;
  String bankName;
  String accountNumber;
  String upiId;
  String ifscCode;
  String gstNumber;
  String remarks;
  String status;
  List<String> images;
  bool isVerified = false;
  String createdAt;
  String updatedAt;
  bool isActive = false;
    String videoUrl;

  VendorModal({
    required this.userId,
    required this.merchantId,
    required this.earnings,
    required this.vendorName,
    required this.bussinessName,
    required this.contactPerson,
    required this.phoneNumber,
    required this.email,
    required this.vendorType,
    required this.businessAddress,
    required this.areaCity,
    required this.postalCode,
    required this.state,
    required this.waterType,
    required this.capacityOptions,
    required this.dailySupply,
    required this.deliveryArea,
    required this.deliveryTimings,
    required this.bankName,
    required this.accountNumber,
    required this.upiId,
    required this.ifscCode,
    required this.gstNumber,
    required this.remarks,
    required this.status,
    required this.images, // Image map is passed as argument
    this.isVerified = false,
    this.createdAt = '',
    this.updatedAt = '',
    this.isActive = false,
    this.videoUrl = '',
  });

  // To convert the model into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'vendorName': vendorName,
      'userId': userId,
      'merchantId': merchantId,
      'earnings': earnings,
      'bussinessName': bussinessName,
      'contactPerson': contactPerson,
      'phoneNumber': phoneNumber,
      'email': email,
      'vendorType': vendorType,
      'businessAddress': businessAddress,
      'areaCity': areaCity,
      'postalCode': postalCode,
      'state': state,
      'waterType': waterType,
      'capacityOptions': capacityOptions,
      'dailySupply': dailySupply,
      'deliveryArea': deliveryArea,
      'deliveryTimings': deliveryTimings,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'upiId': upiId,
      'ifscCode': ifscCode,
      'gstNumber': gstNumber,
      'remarks': remarks,
      'status': status,
      'images': images,  // Store the images map
      'isVerified': isVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
      'videoUrl': videoUrl,
    };
  }

  // Convert from JSON (Firestore)
  factory VendorModal.fromJson(Map<String, dynamic> json) {
    return VendorModal(
      merchantId: json['merchantId'] ?? '',
      userId: json['userId'] ?? '',
      vendorName: json['vendorName'] ?? '',
      earnings: json['earnings'] != null ? json['earnings'].toDouble() : 0.0,
      bussinessName: json['bussinessName'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      vendorType: json['vendorType'] ?? '',
      businessAddress: json['businessAddress'] ?? '',
      areaCity: json['areaCity'] ?? '',
      postalCode: json['postalCode'] ?? '',
      state: json['state'] ?? '',
      waterType: json['waterType'] ?? '',
      capacityOptions: json['capacityOptions'] ?? '',
      dailySupply: json['dailySupply'] ?? '',
      deliveryArea: json['deliveryArea'] ?? '',
      deliveryTimings: json['deliveryTimings'] ?? '',
      bankName: json['bankName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      upiId: json['upiId'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      gstNumber: json['gstNumber'] ?? '',
      remarks: json['remarks'] ?? '',
      status: json['status'] ?? '',
      images: List<String>.from(json['images'] ?? []), // Parsing the images list
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      isActive: json['isActive'] ?? false,
      videoUrl: json['videoUrl'] ?? '',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'vendorId': userId,
      'vendorName': vendorName,
      'userId': userId,
      'earnings': earnings,
      'bussinessName': bussinessName,
      'contactPerson': contactPerson,
      'phoneNumber': phoneNumber,
      'email': email,
      'vendorType': vendorType,
      'businessAddress': businessAddress,
      'areaCity': areaCity,
      'postalCode': postalCode,
      'state': state,
      'waterType': waterType,
      'capacityOptions': capacityOptions,
      'dailySupply': dailySupply,
      'deliveryArea': deliveryArea,
      'deliveryTimings': deliveryTimings,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'upiId': upiId,
      'ifscCode': ifscCode,
      'gstNumber': gstNumber,
      'remarks': remarks,
      'status': status,
      'images': images, // Store the images map
      'isVerified': isVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
      'videoUrl': videoUrl,
    };
  }

  factory VendorModal.fromMap(Map<String, dynamic> map) {
    return VendorModal(
      merchantId: map['merchantId'] ?? '',
      userId: map['userId'] ?? '',
      vendorName: map['vendorName'] ?? '',
      earnings: map['earnings'] != null ? map['earnings'].toDouble() : 0.0,
      bussinessName: map['bussinessName'] ?? '',
      contactPerson: map['contactPerson'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      vendorType: map['vendorType'] ?? '',
      businessAddress: map['businessAddress'] ?? '',
      areaCity: map['areaCity'] ?? '',
      postalCode: map['postalCode'] ?? '',
      state: map['state'] ?? '',
      waterType: map['waterType'] ?? '',
      capacityOptions: map['capacityOptions'] ?? '',
      dailySupply: map['dailySupply'] ?? '',
      deliveryArea: map['deliveryArea'] ?? '',
      deliveryTimings: map['deliveryTimings'] ?? '',
      bankName: map['bankName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      upiId: map['upiId'] ?? '',
      ifscCode: map['ifscCode'] ?? '',
      gstNumber: map['gstNumber'] ?? '',
      remarks: map['remarks'] ?? '',
      status: map['status'] ?? '',
      images: List<String>.from(map['images'] ?? []), // Extracting images list
      isVerified: map['isVerified'] ?? false,
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      isActive: map['isActive'] ?? false,
      videoUrl: map['videoUrl'] ?? '',
    );
  }
}
