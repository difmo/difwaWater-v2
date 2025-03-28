import 'dart:io';
import 'package:difwa/config/app_textstyle.dart';
import 'package:difwa/controller/admin_controller/add_store_controller.dart';
import 'package:difwa/routes/store_bottom_bar.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateStorePage extends StatefulWidget {
  const CreateStorePage({super.key});

  @override
  _CreateStorePageState createState() => _CreateStorePageState();
}

class _CreateStorePageState extends State<CreateStorePage> {
  final AddStoreController controller = Get.put(AddStoreController());
  File? _image;

  // Future<void> _pickImage(ImageSource source) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: source);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //       controller.setImage(_image!); // Set the image in the controller
  //     });
  //   }
  // }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () {
                // _pickImage(ImageSource.camera);
                // Navigator.of(context).pop();
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                // _pickImage(ImageSource.gallery);
                // Navigator.of(context).pop();
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.whiteColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                'Fill all details to become a seller',
                style: AppTTextStyle.heading24Black,
              ),
              const SizedBox(height: 20),
              Form(
                key: controller.formKey,
                child: Column(
                  children: <Widget>[
                    _buildTextField('Shop Name', Icons.store, false,
                        controller: controller.shopnameController),
                    const SizedBox(height: 10),
                    _buildTextField('Owner Name', Icons.person, false,
                        controller: controller.ownernameController),
                    const SizedBox(height: 10),
                    _buildTextField('Email', Icons.email, false,
                        controller: controller.emailController),
                    const SizedBox(height: 10),
                    _buildTextField('Mobile Number', Icons.phone, false,
                        controller: controller.mobileController),
                    const SizedBox(height: 10),
                    _buildTextField(
                        'UPI ID', Icons.account_balance_wallet, false,
                        controller: controller.upiIdController),
                    const SizedBox(height: 10),
                    _buildTextField('Address', Icons.home, false,
                        controller: controller.storeaddressController),
                    const SizedBox(height: 20),

                    // Image Selection Box
                    // GestureDetector(
                    //   onTap: _showImageSourceDialog,
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: ThemeConstants.primaryColorNew),
                    //       borderRadius: BorderRadius.circular(5.0),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //               vertical: 8, horizontal: 16.0),
                    //           child: Text('Select Image',
                    //               style: AppStyle.heading2Black),
                    //         ),
                    //         if (_image != null) ...[
                    //           Image.file(
                    //             _image!,
                    //             height: 60,
                    //             width: 60,
                    //             fit: BoxFit.cover,
                    //           ),
                    //         ],
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        bool isSuccess= await controller.submitForm(_image);
                        if (isSuccess) {
                          Get.offAll(() =>
                             BottomStoreHomePage()); 
                                } else {
                          Get.snackbar('Error',
                              'Failed to create the store. Please try again.',
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        backgroundColor: ThemeConstants.primaryColorNew,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Create Store',
                        style: AppTTextStyle.headingWhite, // Apply your style here
                      ),
                    ),

                    // ElevatedButton(
                    //   onPressed: () async {
                    //     await controller.submitForm(_image); 
                    //             Get.offAllNamed(AppRoutes.storebottombar);
                    //     // Call submitForm
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 50, vertical: 15),
                    //     backgroundColor: ThemeConstants.primaryColorNew,
                    //     foregroundColor: Colors.white,
                    //   ),
                    //   child: Text(
                    //     'Create Store',
                    //     style: AppStyle.headingWhite, // Apply your style here
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, IconData icon, bool isObscure,
      {TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: ThemeConstants.primaryColorNew),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ThemeConstants.primaryColorNew),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ThemeConstants.primaryColorNew),
        ),
        labelStyle: AppTTextStyle.greyText16,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        if (labelText == 'Shop Name' || labelText == 'Owner Name') {
          if (value.length < 3) {
            return '$labelText must be at least 3 characters long';
          }
        }
        if (labelText == 'Mobile Number') {
          if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
            return 'Please enter a valid 10-digit mobile number';
          }
        }
        if (labelText == 'Email') {
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Please enter a valid email address';
          }
        }
        return null;
      },
    );
  }
}
