import 'dart:io';

import 'package:difwa/controller/admin_controller/vendors_controller.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

class VendorMultiStepForm extends StatefulWidget {
  const VendorMultiStepForm({super.key});

  @override
  State<VendorMultiStepForm> createState() => _VendorMultiStepFormState();
}

class _VendorMultiStepFormState extends State<VendorMultiStepForm> {
  final PageController _controller = PageController();
  final VendorsController controller = Get.put(VendorsController());
  List<XFile?> imageFiles = [
    null, // Aadhaar card image
    null, // PAN card image
    null, // Passport photo image
    null, // Business license image
    null, // Water quality certificate image
    null, // Identity proof image
    null, // Bank document image
  ];

  int _currentStep = 0;
  List<XFile> selectedImages = [];
  final _formKey = GlobalKey<FormState>();

  // Form Data
  String vendorName = '';
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

  Widget textInput(String label, String hint, IconData icon,
      Function(String) onChanged, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        CommonTextField(
          inputType: InputType.name,
          controller: controller,
          hint: hint,
          icon: icon,
          onChanged: onChanged,
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
        _imagePreviewItem("Bank Document6666", imageFiles[6]),
        const SizedBox(height: 20),
        CustomButton(
          text: "Submit",
          onPressed: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Form submitted")));
                // File  ff=File(imageFiles[0]!.path);
            controller.submitForm2(imageFiles);
            // Get.toNamed(
            //   AppRoutes.home,
            // );
          },
        ),
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
          File(selectedImages[index].path),
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
      setState(() {
        if (documentType == "Aadhaar Card") {
          aadhaarCardImage = pickedFile;
          imageFiles[0] = pickedFile;
        } else if (documentType == "PAN Card") {
          panCardImage = pickedFile;
          imageFiles[1] = pickedFile;
        } else if (documentType == "Passport Photo") {
          passportPhotoImage = pickedFile;
          imageFiles[2] = pickedFile;
        } else if (documentType == "Business License") {
          businessLicenseImage = pickedFile;
          imageFiles[3] = pickedFile;
        } else if (documentType == "Water Quality Certificate") {
          waterQualityCertificateImage = pickedFile;
          imageFiles[4] = pickedFile;
        } else if (documentType == "Identity Proof") {
          identityProofImage = pickedFile;
          imageFiles[5] = pickedFile;
        } else if (documentType == "Bank Document") {
          bankDocumentImage = pickedFile;
          imageFiles[6] = pickedFile;
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

  List<Widget> get steps => [
        // Step 1 - Basic Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            stepHeader("Basic Vendor Info"),
            textInput("Vendor Name", "Enter vendor name", Icons.business,
                (value) => vendorName = value, controller.vendorNameController),
            textInput("Bussiness Name", "Enter vendor name", Icons.business,
                (value) => vendorName = value, controller.bussinessNameController),
            textInput(
                "Contact Person Name",
                "Enter name",
                Icons.person,
                (value) => contactPerson = value,
                controller.contactPersonController),
            textInput(
                "Phone Number",
                "Enter phone number",
                Icons.phone,
                (value) => phoneNumber = value,
                controller.phoneNumberController),
            textInput("Email", "Enter email", Icons.email,
                (value) => email = value, controller.emailController),
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
                controller.businessAddressController),
            textInput("Area/City", "Enter area or city", Icons.location_city,
                (value) => areaCity = value, controller.areaCityController),
            textInput("PIN/ZIP Code", "Enter postal code", Icons.pin,
                (value) => postalCode = value, controller.postalCodeController),
            textInput("State/Province", "Enter state", Icons.location_on,
                (value) => state = value, controller.stateController),
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
                controller.capacityOptionsController),
            textInput(
                "Daily Supply Capacity (in Litres)",
                "e.g. 2000",
                Icons.local_drink,
                (value) => dailySupply = value,
                controller.dailySupplyController),
            textInput(
                "Delivery Area Covered",
                "Enter area",
                Icons.map,
                (value) => deliveryArea = value,
                controller.deliveryAreaController),
            textInput(
                "Delivery Timings",
                "e.g. 6 AM - 8 PM",
                Icons.access_time,
                (value) => deliveryTimings = value,
                controller.deliveryTimingsController),
          ],
        ),

        // Step 4 - KYC Documents
// Step 4 - KYC Documents
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
                () => pickFile("Bank Document"), imageFiles[6]),
          ],
        ),

        // Step 5 - Financial Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            stepHeader("Financial / Payment Info"),
            textInput("Bank Name", "Enter bank name", Icons.account_balance,
                (value) => bankName = value, controller.bankNameController),
            textInput(
                "Account Number",
                "Enter account number",
                Icons.account_box,
                (value) => accountNumber = value,
                controller.accountNumberController),
            textInput("IFSC/SWIFT Code", "Enter IFSC/SWIFT", Icons.code,
                (value) => ifscCode = value, controller.ifscCodeController),
            dropdownInput("Payment Terms", ["Prepaid", "Postpaid", "Weekly"],
                (value) => status = value ?? ''),
            textInput(
                "GST Number / Tax ID",
                "Enter GST/Tax ID",
                Icons.business_center,
                (value) => gstNumber = value,
                controller.gstNumberController),
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
