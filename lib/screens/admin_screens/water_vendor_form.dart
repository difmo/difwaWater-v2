import 'dart:io';

import 'package:difwa/controller/admin_controller/vendors_controller.dart';
import 'package:difwa/routes/store_bottom_bar.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

import 'package:image_picker/image_picker.dart';

class VendorMultiStepForm extends StatefulWidget {
  const VendorMultiStepForm({super.key});

  @override
  State<VendorMultiStepForm> createState() => _VendorMultiStepFormState();
}

class _VendorMultiStepFormState extends State<VendorMultiStepForm> {
  final PageController _controller = PageController();
  final VendorsController controller = Get.put(VendorsController());
  VideoPlayerController? _videoPlayerController;

  List<String> imageUrl = [
    "", 
    "", 
    "", 
    "", 
    "", 
    "", 
    "",
  ];

  int _currentStep = 0;
  bool isLoading = false;
  List<XFile?> selectedImages = [];
  List<XFile?> businessImages = [];
  List<XFile?> concatenatedList = [];
  XFile? businessVideo;

  final _formKey = GlobalKey<FormState>();

  // Form Data
  String vendorName = '';
  String bussinessName = '';
  String contactPerson = '';
  String phoneNumber = '';
  String email = '';
  String vendorType = '';
  String businessAddress = '';
  String areaCity = '';
  String postalCode = '';
  String state = '';
  String waterType = '';
  String capacityOptions = '';
  String dailySupply = '';
  String deliveryArea = '';
  String deliveryTimings = '';
  String bankName = '';
  String accountNumber = '';
  String upiId = '';
  String ifscCode = '';
  String gstNumber = '';
  String remarks = '';
  String status = '';
  XFile? aadhaarCardImage;
  XFile? panCardImage;
  XFile? passportPhotoImage;
  XFile? businessLicenseImage;
  XFile? waterQualityCertificateImage;
  XFile? identityProofImage;
  XFile? bankDocumentImage;

  void nextStep() {
    if (_currentStep < 5) {
      setState(() => _currentStep++);
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  Widget stepHeader(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );

  InputDecoration inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      );

  Widget textInput(
    String label,
    String hint,
    IconData icon,
    Function(String) onChanged,
    TextEditingController controller,
    InputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        CommonTextField(
          controller: controller,
          hint: hint,
          icon: icon,
          onChanged: onChanged,
          inputType: type,
        ),
      ]),
    );
  }

  Widget dropdownInput(
      String label, List<String> items, Function(String?) onChanged) {
    String? selectedValue;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          dropdownColor: Colors.white,
          decoration: inputDecoration("Select"),
          value: selectedValue,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
            selectedValue = value;
            onChanged(value);
          },
        ),
      ]),
    );
  }

  Widget uploadCard(String label, Function() onTap, XFile? image) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: image == null
              ? Text("Upload $label",
                  style: const TextStyle(color: Colors.grey))
              : Image.file(
                  File(image.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
      ),
    );
  }

  // Step Preview
  Widget previewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        stepHeader("Preview & Submit"),
        _previewItem("Vendor Name", vendorName),
        _previewItem("Contact Person", contactPerson),
        _previewItem("Phone Number", phoneNumber),
        _previewItem("Email", email),
        _previewItem("Vendor Type", vendorType),
        _previewItem("Business Address", businessAddress),
        _previewItem("Area/City", areaCity),
        _previewItem("PIN/ZIP Code", postalCode),
        _previewItem("State/Province", state),
        _previewItem("Water Type", waterType),
        _previewItem("Capacity Options", capacityOptions),
        _previewItem("Daily Supply Capacity", dailySupply),
        _previewItem("Delivery Area", deliveryArea),
        _previewItem("Delivery Timings", deliveryTimings),
        _previewItem("Bank Name", bankName),
        _previewItem("Account Number", accountNumber),
        _previewItem("IFSC Code", ifscCode),
        _previewItem("GST Number", gstNumber),
        _previewItem("Remarks", remarks),
        _previewItem("Status", status),
        const SizedBox(height: 20),
        // Displaying Images with Labels
        _imagePreviewItem("Aadhaar Card", aadhaarCardImage),
        _imagePreviewItem("PAN Card", panCardImage),
        _imagePreviewItem("Passport Photo", passportPhotoImage),
        _imagePreviewItem("Business License", businessLicenseImage),
        _imagePreviewItem(
            "Water Quality Certificate", waterQualityCertificateImage),
        _imagePreviewItem("Identity Proof", identityProofImage),
        _imagePreviewItem("Bank Document", bankDocumentImage),
        displayBusinessImages(),
        videoPreview(),

        const SizedBox(height: 20),
        CustomButton(
          text: isLoading ? "Loading..." : "Submit",
          onPressed: () async {
            // concatenatedList.addAll(imageUrl);
            // concatenatedList.addAll(businessImages);
            // concatenatedList.add(businessVideo);
            setState(() {
              isLoading = true;
            });

            bool isSuccess = await controller.submitForm2(concatenatedList);
            if (isSuccess) {
              Get.offAll(() => BottomStoreHomePage());
              setState(() {
                isLoading = false;
              });
            } else {
              Get.snackbar(
                  'Error', 'Failed to create the store. Please try again.',
                  snackPosition: SnackPosition.BOTTOM);
            }
          },
        )
      ],
    );
  }

  Widget _imagePreviewItem(String label, XFile? image) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          image == null
              ? const Text("No image uploaded")
              : Image.file(
                  File(image.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
        ],
      ),
    );
  }

  Widget videoPreview() {
    if (businessVideo == null) {
      return Center(child: Text("No video selected"));
    }

    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: _videoPlayerController != null &&
                  _videoPlayerController!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController!),
                )
              : Center(child: CircularProgressIndicator()),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _videoPlayerController != null &&
                        _videoPlayerController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  if (_videoPlayerController != null) {
                    if (_videoPlayerController!.value.isPlaying) {
                      _videoPlayerController!.pause();
                    } else {
                      _videoPlayerController!.play();
                    }
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> pickBusinessVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedVideo =
        await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      setState(() {
        businessVideo = pickedVideo; 
      });
    }
  }

  Widget uploadVideoCard(String label, Function() onTap, XFile? video) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: video == null
              ? Text("Upload $label",
                  style: const TextStyle(color: Colors.grey))
              : Icon(Icons.video_library,
                  size: 40, color: Colors.blue), // Show a video icon
        ),
      ),
    );
  }

  Future<void> pickBusinessImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        businessImages = pickedFiles; // Store the selected images
      });
    }
  }

  Widget displayBusinessImages() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: businessImages.length,
      itemBuilder: (context, index) {
        return Image.file(
          File(businessImages[index]!.path),
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget imagePreview() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: selectedImages.length,
      itemBuilder: (context, index) {
        return Image.file(
          File(selectedImages[index]!.path),
          fit: BoxFit.cover,
        );
      },
    );
  }



  Future<void> pickFile(String documentType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() async {
        if (documentType == "Aadhaar Card") {
          aadhaarCardImage = pickedFile;
          String url =  await uploadImage(File(pickedFile.path), documentType);
          imageUrl[0] = url;
        } else if (documentType == "PAN Card") {
          panCardImage = pickedFile;
          String url =  await uploadImage(File(pickedFile.path), documentType);
          imageUrl[1] = url;
        } else if (documentType == "Passport Photo") {
          String url =  await uploadImage(File(pickedFile.path), documentType);
          imageUrl[2] = url;
          passportPhotoImage = pickedFile;
        } else if (documentType == "Business License") {
          String url =  await uploadImage(File(pickedFile.path), documentType);
          imageUrl[3] = url;
          businessLicenseImage = pickedFile;
        } else if (documentType == "Water Quality Certificate") {
          String url =  await uploadImage(File(pickedFile.path), documentType);
          imageUrl[4] = url;
          waterQualityCertificateImage = pickedFile;
        } else if (documentType == "Identity Proof") {
          String url =  await uploadImage(File(pickedFile.path), documentType);
          imageUrl[5] = url;
          identityProofImage = pickedFile;
        } else if (documentType == "Bank Document") {
          String url =  await uploadImage(File(pickedFile.path), documentType);
          imageUrl[6] = url;
          bankDocumentImage = pickedFile;
        }
      });
    }
  }

  Widget _previewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label : ",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "$value",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<String> uploadImage(File image, String documentType) async {
    String url = await controller.uploadImage(image, documentType);
    return url;
  }

  List<Widget> get steps => [
        // Step 1 - Basic Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            stepHeader("Basic Vendor Info"),
            textInput(
                "Vendor Name",
                "Enter vendor name",
                Icons.business,
                (value) => vendorName = value,
                controller.vendorNameController,
                InputType.text),
            textInput(
                "Bussiness Name",
                "Enter vendor name",
                Icons.business,
                (value) => bussinessName = value,
                controller.bussinessNameController,
                InputType.text),
            textInput(
                "Contact Person Name",
                "Enter name",
                Icons.person,
                (value) => contactPerson = value,
                controller.contactPersonController,
                InputType.text),
            textInput(
                "Phone Number",
                "Enter phone number",
                Icons.phone,
                (value) => phoneNumber = value,
                controller.phoneNumberController,
                InputType.phone),
            textInput(
                "Email",
                "Enter email",
                Icons.email,
                (value) => email = value,
                controller.emailController,
                InputType.email),
            dropdownInput("Vendor Type", ["Bottled", "Tanker", "RO", "Mineral"],
                (value) => vendorType = value ?? ''),
          ],
        ),

        // Step 2 - Location
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            stepHeader("Location Details"),
            textInput(
                "Business Address",
                "Enter address",
                Icons.location_on,
                (value) => businessAddress = value,
                controller.businessAddressController,
                InputType.address),
            textInput(
                "Area/City",
                "Enter area or city",
                Icons.location_city,
                (value) => areaCity = value,
                controller.areaCityController,
                InputType.text),
            textInput(
                "PIN/ZIP Code",
                "Enter postal code",
                Icons.pin,
                (value) => postalCode = value,
                controller.postalCodeController,
                InputType.pin),
            textInput(
                "State/Province",
                "Enter state",
                Icons.location_on,
                (value) => state = value,
                controller.stateController,
                InputType.text),
          ],
        ),

        // Step 3 - Service
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            stepHeader("Service Details"),
            dropdownInput(
                "Type of Water Supplied",
                ["Drinking", "Industrial", "RO", "Mineral"],
                (value) => waterType = value ?? ''),
            textInput(
                "Capacity Options",
                "e.g. 20L, 500L, 1000L",
                Icons.filter_1,
                (value) => capacityOptions = value,
                controller.capacityOptionsController,
                InputType.text),
            textInput(
                "Daily Supply Capacity (in Litres)",
                "e.g. 2000",
                Icons.local_drink,
                (value) => dailySupply = value,
                controller.dailySupplyController,
                InputType.text),
            textInput(
                "Delivery Area Covered",
                "Enter area",
                Icons.map,
                (value) => deliveryArea = value,
                controller.deliveryAreaController,
                InputType.text),
            textInput(
                "Delivery Timings",
                "e.g. 6 AM - 8 PM",
                Icons.access_time,
                (value) => deliveryTimings = value,
                controller.deliveryTimingsController,
                InputType.text),
          ],
        ),


        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            stepHeader("KYC / Documents"),
            uploadCard("Aadhaar Card", () => pickFile("Aadhaar Card"),
                aadhaarCardImage),
            uploadCard("PAN Card", () => pickFile("PAN Card"), panCardImage),
            uploadCard("Passport-size Photo", () => pickFile("Passport Photo"),
                passportPhotoImage),
            uploadCard("Business License", () => pickFile("Business License"),
                businessLicenseImage),
            uploadCard(
                "Water Quality Certificate",
                () => pickFile("Water Quality Certificate"),
                waterQualityCertificateImage),
            uploadCard("Identity Proof", () => pickFile("Identity Proof"),
                identityProofImage),
            uploadCard("Bank Passbook or Cancelled Cheque",
                () => pickFile("Bank Document"), bankDocumentImage),
            uploadCard("Business Images", () => pickBusinessImages(),
                businessImages.isEmpty ? null : businessImages[0]),
            uploadVideoCard(
                "Business Video", () => pickBusinessVideo(), businessVideo),
          ],
        ),

        // Step 5 - Financial Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            stepHeader("Financial / Payment Info"),
            textInput(
                "Bank Name",
                "Enter bank name",
                Icons.account_balance,
                (value) => bankName = value,
                controller.bankNameController,
                InputType.text),
            textInput(
                "Account Number",
                "Enter account number",
                Icons.account_box,
                (value) => accountNumber = value,
                controller.accountNumberController,
                InputType.text),
            textInput(
                "UPI ID",
                "Enter UPI ID",
                Icons.account_box,
                (value) => upiId = value,
                controller.upiIdController,
                InputType.text),
            textInput(
                "IFSC/SWIFT Code",
                "Enter IFSC/SWIFT",
                Icons.code,
                (value) => ifscCode = value,
                controller.ifscCodeController,
                InputType.text),
            dropdownInput("Payment Terms", ["Prepaid", "Postpaid", "Weekly"],
                (value) => status = value ?? ''),
            textInput(
                "GST Number / Tax ID",
                "Enter GST/Tax ID",
                Icons.business_center,
                (value) => gstNumber = value,
                controller.gstNumberController,
                InputType.text),
          ],
        ),

        // Step 6 - Preview
        previewStep(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.whiteColor,
      appBar: AppBar(
        title: const Text("Register Water Vendor"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  Text("Step ${_currentStep + 1} of ${steps.length}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    minHeight: 8,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    value: (_currentStep + 1) / steps.length,
                    color: Colors.blue,
                    backgroundColor: Colors.blue.shade100,
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                children: steps
                    .map((step) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(child: step),
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: CustomButton(
                        text: "Previous",
                        onPressed: previousStep,
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text:
                          _currentStep == steps.length - 1 ? "Finish" : "Next",
                      onPressed: nextStep,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
