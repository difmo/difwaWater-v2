import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:difwa/controller/admin_controller/vendors_controller.dart';
import 'package:difwa/models/stores_models/store_new_modal.dart';

class EditVendorDetailsScreen extends StatefulWidget {
  final VendorModal? vendorModal;

  EditVendorDetailsScreen({Key? key, this.vendorModal}) : super(key: key);

  @override
  _EditVendorDetailsScreenState createState() =>
      _EditVendorDetailsScreenState();
}

class _EditVendorDetailsScreenState extends State<EditVendorDetailsScreen> {
  final VendorsController controller = Get.put(VendorsController());

  bool isDataFetched = false;  // Flag to track if the data has been fetched
  int currentStep = 0;
  List<String> images = []; // List to store the image URLs

  // List of steps for the Stepper widget
  List<Step> get steps => [
    Step(
      title: Text('Vendor Info'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(controller.vendorNameController, 'Vendor Name'),
          _buildTextField(controller.bussinessNameController, 'Business Name'),
          _buildTextField(controller.emailController, 'Email'),
          _buildTextField(controller.phoneNumberController, 'Phone Number'),
        ],
      ),
      isActive: currentStep >= 0,
    ),
    Step(
      title: Text('Address & Details'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(controller.businessAddressController, 'Business Address'),
          _buildTextField(controller.areaCityController, 'Area/City'),
          _buildTextField(controller.postalCodeController, 'Postal Code'),
          _buildTextField(controller.stateController, 'State'),
        ],
      ),
      isActive: currentStep >= 1,
    ),
    Step(
      title: Text('Water & Delivery'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(controller.waterTypeController, 'Water Type'),
          _buildTextField(controller.capacityOptionsController, 'Capacity Options'),
          _buildTextField(controller.dailySupplyController, 'Daily Supply'),
          _buildTextField(controller.deliveryAreaController, 'Delivery Area'),
          _buildTextField(controller.deliveryTimingsController, 'Delivery Timings'),
        ],
      ),
      isActive: currentStep >= 2,
    ),
    Step(
      title: Text('Bank Details'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(controller.bankNameController, 'Bank Name'),
          _buildTextField(controller.accountNumberController, 'Account Number'),
          _buildTextField(controller.upiIdController, 'UPI ID'),
          _buildTextField(controller.ifscCodeController, 'IFSC Code'),
        ],
      ),
      isActive: currentStep >= 3,
    ),
    Step(
      title: Text('Others'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(controller.gstNumberController, 'GST Number'),
          _buildTextField(controller.remarksController, 'Remarks'),
          _buildTextField(controller.statusController, 'Status'),
          // Add a widget to display images
          if (images.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: images.map((imageUrl) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
        ],
      ),
      isActive: currentStep >= 4,
    ),
  ];

  // Fetch Vendor data if provided in widget.vendorModal or using the controller
  Future<void> fetchVendorData() async {
    if (!mounted) return;

    final vendor = await controller.fetchStoreData();
    print(vendor);

    // Check if vendor data exists and set state
    if (vendor != null && mounted) {
      setState(() {
        controller.vendorNameController.text = vendor.vendorName;
        controller.bussinessNameController.text = vendor.bussinessName;
        controller.emailController.text = vendor.email;
        controller.phoneNumberController.text = vendor.phoneNumber;
        controller.contactPersonController.text = vendor.contactPerson;
        controller.businessAddressController.text = vendor.businessAddress;
        controller.areaCityController.text = vendor.areaCity;
        controller.postalCodeController.text = vendor.postalCode;
        controller.stateController.text = vendor.state;
        controller.waterTypeController.text = vendor.waterType;
        controller.capacityOptionsController.text = vendor.capacityOptions;
        controller.dailySupplyController.text = vendor.dailySupply;
        controller.deliveryAreaController.text = vendor.deliveryArea;
        controller.deliveryTimingsController.text = vendor.deliveryTimings;
        controller.bankNameController.text = vendor.bankName;
        controller.accountNumberController.text = vendor.accountNumber;
        controller.upiIdController.text = vendor.upiId;
        controller.ifscCodeController.text = vendor.ifscCode;
        controller.gstNumberController.text = vendor.gstNumber;
        controller.remarksController.text = vendor.remarks;
        controller.statusController.text = vendor.status;

        images = vendor.images ??[];
        isDataFetched = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isDataFetched) {
      fetchVendorData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Vendor Details'),
      ),
      body: Stepper(
        steps: steps,
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep < steps.length - 1) {
            setState(() {
              currentStep += 1;
            });
          } else {
            // Handle form submission when last step is reached
            controller.editVendorDetails();
            Get.snackbar('Success', 'Vendor details updated successfully!',
                snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep -= 1;
            });
          }
        },
        onStepTapped: (index) {
          setState(() {
            currentStep = index;
          });
        },
        type: StepperType.vertical,
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  // Helper method to build TextFormField widgets
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w200,
            fontSize: 16,
          ),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: TextStyle(
            color: Colors.black12,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[200]!,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
          labelText: label,
          fillColor: Colors.grey[100],
          filled: true,
        ),
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
