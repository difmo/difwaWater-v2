import 'package:cloud_firestore/cloud_firestore.dart';

class VendorModal {
  String userId;
  String merchantId;
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
  String aadhaarCardImage;
  String panCardImage;
  String passportPhotoImage;
  String businessLicenseImage;
  String waterQualityCertificateImage;
  String identityProofImage;
  String bankDocumentImage;

  VendorModal({
    required this.userId,
    required this.merchantId,
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
    required this.aadhaarCardImage,
    required this.panCardImage,
    required this.passportPhotoImage,
    required this.businessLicenseImage,
    required this.waterQualityCertificateImage,
    required this.identityProofImage,
    required this.bankDocumentImage,
  });

  // To convert the model into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'vendorName': vendorName,
      'userId': userId,
      'merchantId': merchantId,
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
      'aadhaarCardImage': aadhaarCardImage,
      'panCardImage': panCardImage,
      'passportPhotoImage': passportPhotoImage,
      'businessLicenseImage': businessLicenseImage,
      'waterQualityCertificateImage': waterQualityCertificateImage,
      'identityProofImage': identityProofImage,
      'bankDocumentImage': bankDocumentImage,
    };
  }

  // Convert from JSON (Firestore)
  factory VendorModal.fromJson(Map<String, dynamic> json) {
    return VendorModal(
      merchantId: json['merchantId'] ?? '',

      userId: json['userId'] ?? '',
      vendorName: json['vendorName'] ?? '',
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
      aadhaarCardImage: json['aadhaarCardImage'] 
          ??'',
      panCardImage: json['panCardImage']  ??'',
      passportPhotoImage: json['passportPhotoImage']  ??'',
      businessLicenseImage: json['businessLicenseImage'] ??'',
      waterQualityCertificateImage: json['waterQualityCertificateImage']  ??'',
      identityProofImage: json['identityProofImage'] ??'',
      bankDocumentImage: json['bankDocumentImage'] ??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'vendorId': userId,
      'vendorName': vendorName,
      'userId': userId,
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
      'aadhaarCardImage': aadhaarCardImage,
      'panCardImage': panCardImage,
      'passportPhotoImage': passportPhotoImage,
      'businessLicenseImage': businessLicenseImage,
      'waterQualityCertificateImage': waterQualityCertificateImage,
      'identityProofImage': identityProofImage,
      'bankDocumentImage': bankDocumentImage,
    };
  }

  factory VendorModal.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return VendorModal.fromJson(data);
  }
}
