import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:difwa/config/app_color.dart';
import 'package:difwa/controller/address_controller.dart';
import 'package:difwa/models/address_model.dart';
import 'package:difwa/utils/app__text_style.dart';
import 'package:difwa/utils/loader.dart'; // Assuming this is where your custom Loader is defined
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/utils/validators.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:difwa/widgets/subscribe_button_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressForm extends StatefulWidget {
  final Address address;
  final String flag;
  const AddressForm({
    super.key,
    required this.address,
    required this.flag,
  });

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final AddressController address = AddressController();
  bool _isChecked = false;
  bool _isdeleted = false;
  final bool _isSelected = false; // Checkbox state

  Country? selectedCountry; // To store the selected country

  // Form keys for each section (if you want separate validation for each)
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyPhone = GlobalKey<FormState>();
  final _formKeyAddress = GlobalKey<FormState>();
  final _formPin = GlobalKey<FormState>();
  final _formState = GlobalKey<FormState>();
  final _formCity = GlobalKey<FormState>();
  final _formfloor = GlobalKey<FormState>();

  bool _isSubmitting = false; // State to handle submission progress

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.address.name;
    _phoneController.text = widget.address.phone;
    _zipController.text = widget.address.zip;
    _stateController.text = widget.address.state;
    _cityController.text = widget.address.city;
    _addressController.text = widget.address.street;
    _streetController.text = widget.address.street;

    _isChecked = widget.address.saveAddress;
    _isdeleted = widget.address.isDeleted;
  }

// Function to save a new address
  Future<bool> saveAddress() async {
    try {
      // Assuming _addressController.saveAddress() is returning void,
      // you need to change it to return a boolean indicating success or failure.
      await address.saveAddress(
        Address(
          name: _nameController.text,
          phone: _phoneController.text,
          zip: _zipController.text,
          state: _stateController.text,
          city: _cityController.text,
          street: _streetController.text,
          floor: _addressController.text,
          saveAddress: _isChecked,
          userId: "", // Dynamically get the userId if necessary
          isDeleted: _isdeleted,
          isSelected: _isSelected,
          docId: "",
          country: '', // Empty for a new address
        ),
      );
      return true; // Indicate success
    } catch (e) {
      // If there's an error, log it and return false
      print("Error saving address: $e");
      return false;
    }
  }

// Function to update an existing address
  Future<bool> updateAddress() async {
    try {
      // Assuming _addressController.updateAddress() is returning void,
      // you need to change it to return a boolean indicating success or failure.
      await address.updateAddress(
        Address(
          name: _nameController.text,
          phone: _phoneController.text,
          zip: _zipController.text,
          state: _stateController.text,
          city: _cityController.text,
          street: _streetController.text,
          floor: _addressController.text,
          saveAddress: _isChecked,
          userId: "", // Dynamically get the userId if necessary
          isDeleted: _isdeleted,
          isSelected: _isSelected,
          docId: "",
          country: '', // Empty for a new addr
        ),
      );
      return true; // Indicate success
    } catch (e) {
      // If there's an error, log it and return false
      print("Error updating address: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.whiteColor,
      appBar: AppBar(
        backgroundColor: ThemeConstants.whiteColor,
        title: Text('Save Address', style: AppTextStyle.Text18700),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
            child: ListView(
              children: [
                Form(
                  key: _formKeyName,
                  child: CommonTextField(
                    controller: _nameController,
                    inputType: InputType.name,
                    onChanged: (String) {
                      _formKeyName.currentState!.validate();
                    },
                    label: 'Full Name',
                    hint: 'Full Name',
                    icon: Icons.person,
                    validator: Validators.validateName,
                  ),
                ),
                SizedBox(height: 20),
                // Phone Number with country code
                Form(
                  key: _formKeyPhone,
                  child: CommonTextField(
                    controller: _phoneController,
                    inputType: InputType.phone,
                    label: 'Phone Number',
                    hint: 'Phone Number',
                    icon: Icons.phone,
                    onChanged: (value) {
                      _formKeyPhone.currentState!.validate();
                    },
                    validator: Validators.validatePhone,
                  ),
                ),

                SizedBox(height: 20),

                // ZIP Code
                Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formPin,
                        child: CommonTextField(
                          inputType: InputType.pin,
                          controller: _zipController,
                          onChanged: (value) {
                            _formPin.currentState!.validate();
                          },
                          label: 'Pincode',
                          hint: 'Pincode',
                          validator: Validators.validatePin,
                        ),
                      ),
                    ),
                    // City
                    SizedBox(width: 10),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.inputfield),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("Use my location"),
                    )),
                  ],
                ),
                SizedBox(height: 20),

                // City
                Row(
                  children: [
                    Expanded(
                      child: // State
                          Form(
                        key: _formState,
                        child: CommonTextField(
                          inputType: InputType.name,
                          controller: _stateController,
                          onChanged: (value) {
                            _formPin.currentState!.validate();
                          },
                          label: 'State',
                          hint: 'State',
                          validator: Validators.validatestreet,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Form(
                        key: _formCity,
                        child: CommonTextField(
                          inputType: InputType.name,
                          controller: _cityController,
                          onChanged: (value) {
                            _formCity.currentState!.validate();
                          },
                          label: 'City',
                          hint: 'City',
                          validator: Validators.validatestreet,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Street Address
                Form(
                  key: _formKeyAddress,
                  child: CommonTextField(
                    inputType: InputType.address,
                    controller: _addressController,
                    onChanged: (value) {
                      _formKeyAddress.currentState!.validate();
                    },
                    label: 'Housse No.,/Building Name',
                    hint: 'Housse No.,/Building Name',
                    validator: Validators.validatestreet,
                  ),
                ),
                SizedBox(height: 20),
                // Floor Address
                Form(
                  key: _formfloor,
                  child: CommonTextField(
                    inputType: InputType.phone,
                    controller: _streetController,
                    onChanged: (value) {
                      _formfloor.currentState!.validate();
                    },
                    label: 'Road name, Area, Land Mark',
                    hint: 'Road name, Area, Land Mark',
                    validator: Validators().validateFloor,
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(height: 20),

                const SizedBox(height: 24),

                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                        activeColor: AppColors.inputfield, // Color when checked
                        checkColor: AppColors.mywhite, // Color of the checkmark
                      ),
                      Text('Save shipping address'),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: SubscribeButtonComponent(
                    text: widget.flag != "isEdit"
                        ? 'SAVE ADDRESS'
                        : 'UPDATE ADDRESS',
                    onPressed: () async {
                      setState(() {
                        _isSubmitting = true;
                      });

                      // Validate all form fields
                      _formKeyName.currentState!.validate();
                      _formKeyPhone.currentState!.validate();
                      _formKeyAddress.currentState!.validate();
                      _formState.currentState!.validate();
                      _formPin.currentState!.validate();
                      _formCity.currentState!.validate();
                      _formfloor.currentState!.validate();

                      // Check if all form fields are valid
                      if (_formKeyName.currentState!.validate() &&
                          _formfloor.currentState!.validate() &&
                          _formKeyPhone.currentState!.validate() &&
                          _formKeyAddress.currentState!.validate() &&
                          _formState.currentState!.validate() &&
                          _formPin.currentState!.validate() &&
                          _formCity.currentState!.validate()) {
                        // Call saveAddress or updateAddress based on flag
                        bool success;
                        if (widget.flag == 'isEdit') {
                          success = await updateAddress();
                        } else {
                          success = await saveAddress();
                        }
                        // Check if save/update was successful
                        if (success) {
                          Navigator.of(context).pop(true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Failed to save/update address")));
                        }

                        setState(() {
                          _isSubmitting = false;
                        });
                      }
                    },
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),

          // Full-screen loader
          if (_isSubmitting)
            Positioned.fill(
              child: Container(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0), // Semi-transparent overlay
                child: Center(child: Loader()), // Your custom loader widget
              ),
            ),
        ],
      ),
    );
  }
}
