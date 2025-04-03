import 'dart:io';
import 'package:difwa/config/app_color.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/screens/personal_details.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditPersonaldetails extends StatefulWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImage;

  const EditPersonaldetails({
    super.key,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
  });

  @override
  State<EditPersonaldetails> createState() => _EditPersonaldetailsState();
}

class _EditPersonaldetailsState extends State<EditPersonaldetails> {
  File? _selectedImage;
  String selectedCountryCode = "+91 "; 
  final AuthController auth = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name ?? '';
    emailController.text = widget.email ?? '';
    mobileController.text = widget.phone ?? '';
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          title: const Text("Choose Profile Image"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label:
                    const Text("Camera", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.logosecondry),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo, color: Colors.white),
                label: const Text("Gallery",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.logoprimary),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Edit Profile "),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () => _showImageSourceDialog(context),
                      child: ClipOval(
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                              )
                            : (widget.profileImage != null &&
                                    widget.profileImage!.isNotEmpty)
                                ? Image.network(
                                    widget.profileImage!,
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildInitialsAvatar(
                                          widget.name ?? '');
                                    },
                                  )
                                : _buildInitialsAvatar(widget.name ?? ''),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      right: 10,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () => _showImageSourceDialog(context),
                        icon: Icon(Icons.camera_alt,
                            color: AppColors.logosecondry),
                        label: Text('Change',
                            style: TextStyle(color: AppColors.logosecondry)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Text(
                //   nameController.text,
                //   style: const TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black,
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 38.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  CommonTextField(
                    label: 'Name',
                    controller: nameController,
                    icon: Icons.person,
                    inputType: InputType.email,
                  ),
                  const SizedBox(height: 30),
                  CommonTextField(
                    label: 'Email',
                    controller: emailController,
                    icon: Icons.email,
                    inputType: InputType.email,
                    readOnly: true,
                  ),
                  const SizedBox(height: 30),
                  CommonTextField(
                    label: 'Phone',
                    showCountryPicker: true,
                    controller: mobileController,
                    icon: Icons.phone,
                    inputType: InputType.phone,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              child: CustomButton(
                width: double.infinity,
                text: 'Save Changes',
                onPressed: () async {
                  try {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await auth.updateUserDetails(
                        user.uid,
                        emailController.text,
                        nameController.text,
                        selectedCountryCode + mobileController.text,
                        "some_floor_value",
                      );

                      Get.snackbar(
                        "Success",
                        "Details updated successfully",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );

                      await Future.delayed(Duration(seconds: 2));
                      Get.off(() => PersonalDetails());
                    } else {
                      Get.snackbar(
                        "Error",
                        "User not logged in",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      "Failed to update details: $e",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsAvatar(String name) {
    String initials = name.isNotEmpty ? name[0].toUpperCase() : "G";

    return CircleAvatar(
      radius: 65,
      backgroundColor: Colors.blueGrey,
      child: Text(
        initials,
        style: TextStyle(
            fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
