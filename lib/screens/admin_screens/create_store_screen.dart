import 'dart:io';
import 'package:difwa/config/app_textstyle.dart';
import 'package:difwa/controller/admin_controller/vendors_controller.dart';
import 'package:difwa/routes/store_bottom_bar.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateStorePage extends StatefulWidget {
  const CreateStorePage({super.key});

  @override
  _CreateStorePageState createState() => _CreateStorePageState();
}

class _CreateStorePageState extends State<CreateStorePage> {
  final VendorsController controller = Get.put(VendorsController());
  File? _image;

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
                child: Column(children: <Widget>[
                  CommonTextField(
                    inputType: InputType.name,
                    controller: controller.shopnameController,
                    label: 'Shop Name',
                    icon: Icons.store,
                  ),
                  const SizedBox(height: 10),
                  CommonTextField(
                    inputType: InputType.name,
                    controller: controller.ownernameController,
                    label: 'Owner Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  CommonTextField(
                    inputType: InputType.email,
                    controller: controller.emailController,
                    label: 'Email',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 10),
                  CommonTextField(
                    inputType: InputType.phone,
                    controller: controller.mobileController,
                    label: 'Mobile Number',
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 10),
                  CommonTextField(
                    inputType: InputType.name,
                    controller: controller.upiIdController,
                    label: 'UPI ID',
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 10),
                  CommonTextField(
                    inputType: InputType.name,
                    controller: controller.storeaddressController,
                    label: 'Address',
                    icon: Icons.home,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Create Store",
                    onPressed: () async {
                      bool isSuccess = await controller.submitForm(_image);
                      if (isSuccess) {
                        Get.offAll(() => BottomStoreHomePage());
                      } else {
                        Get.snackbar('Error',
                            'Failed to create the store. Please try again.',
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
