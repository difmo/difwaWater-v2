import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:difwa/config/app_color.dart';
import 'package:difwa/controller/address_controller.dart';
import 'package:difwa/models/address_model.dart';
import 'package:difwa/utils/loader.dart'; // Assuming this is where your custom Loader is defined
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/utils/validators.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressForm extends StatefulWidget {
  final Address address;
  final String flag;
  AddressForm({
    super.key,
    required this.address,
    required this.flag,
  });

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  // Controllers for text fields
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  bool _isChecked = false;
  bool _isdeleted = false; // Checkbox state

  final AddressController _addressController = Get.put(AddressController());

  String selectedCountryCode = "+91"; // Default country code
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
    _streetController.text = widget.address.street;
    _cityController.text = widget.address.city;
    _stateController.text = widget.address.state;
    _zipController.text = widget.address.zip;
    _countryController.text = widget.address.country;
    _phoneController.text = widget.address.phone;
    _isChecked = widget.address.saveAddress;
    _isdeleted = widget.address.isDeleted;
    _floorController.text = widget.address.floor;
  }

// Function to save a new address
  Future<bool> saveAddress() async {
    try {
      // Assuming _addressController.saveAddress() is returning void,
      // you need to change it to return a boolean indicating success or failure.
      await _addressController.saveAddress(
        Address(
          name: _nameController.text,
          street: _streetController.text,
          city: _cityController.text,
          state: _stateController.text,
          zip: _zipController.text,
          country: _countryController.text,
          phone: _phoneController.text,
          saveAddress: _isChecked,
          userId: "", // Dynamically get the userId if necessary
          isDeleted: _isdeleted,
          docId: "", // Empty for a new address
          floor: _floorController.text,
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
      await _addressController.updateAddress(
        Address(
          name: _nameController.text,
          street: _streetController.text,
          city: _cityController.text,
          state: _stateController.text,
          zip: _zipController.text,
          country: _countryController.text,
          phone: _phoneController.text,
          saveAddress: _isChecked,
          userId: "", // Dynamically get the userId if necessary
          isDeleted: _isdeleted,
          docId: widget.address.docId, // Pass the existing docId for update
          floor: _floorController.text,
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
        title: Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
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
                    label: 'Name',
                    hint: 'Enter Your Name',
                    icon: Icons.person,
                    validator: Validators.validateName,
                  ),
                ),
                SizedBox(height: 20),
                // Phone Number with country code
                Form(
                  key: _formKeyPhone,
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: (code) {
                          setState(() {
                            selectedCountryCode = code.dialCode!;
                          });
                        },
                        initialSelection: 'IN',
                        favorite: ['+91', '+1'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                      Expanded(
                        child: CommonTextField(
                          controller: _phoneController,
                          inputType: InputType.phone,
                          label: 'Phone Number',
                          hint: 'Enter Your Phone Number',
                          icon: Icons.phone,
                          onChanged: (String) {
                            _formKeyPhone.currentState!.validate();
                          },
                          validator: Validators.validatePhone,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Street Address
                Form(
                  key: _formKeyAddress,
                  child: CommonTextField(
                    inputType: InputType.address,
                    controller: _streetController,
                    onChanged: (value) {
                      _formKeyAddress.currentState!.validate();
                    },
                    label: 'Street Address',
                    hint: 'Flat/Housse No./Building/Apartment',
                    validator: Validators.validatestreet,
                  ),
                ),
                SizedBox(height: 20),
                // Floor Address
                Form(
                  key: _formfloor,
                  child: CommonTextField(
                    inputType: InputType.phone,
                    controller: _floorController,
                    onChanged: (value) {
                      _formfloor.currentState!.validate();
                    },
                    label: 'Floor',
                    hint: 'Enter Floor No.',
                    validator: Validators().validateFloor,
                  ),
                ),
                SizedBox(height: 20),

                // State
                Form(
                  key: _formState,
                  child: CommonTextField(
                    inputType: InputType.name,
                    controller: _stateController,
                    onChanged: (value) {
                      _formPin.currentState!.validate();
                    },
                    label: 'State',
                    hint: 'Enter your state',
                    validator: Validators.validatestreet,
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
                          label: 'ZIP Code',
                          hint: 'Enter your ZIP code',
                          validator: Validators.validatePin,
                        ),
                      ),
                    ),
                    // City
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
                          hint: 'Enter your city',
                          validator: Validators.validatestreet,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Country
                // Country Dropdown (using country_picker package)
                FormField<String>(
                  builder: (state) {
                    return GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          onSelect: (Country country) {
                            setState(() {
                              selectedCountry = country;
                              _countryController.text = country.name;
                            });
                          },
                        );
                      },
                      child: AbsorbPointer(
                        child: CommonTextField(
                          controller: _countryController,
                          inputType: InputType.name,
                          label: 'Country',
                          hint: 'Enter your country',
                          icon: Icons.arrow_drop_down,
                          validator: Validators.validatestreet,
                          onChanged: (String value) {
                            // Handle the onChanged callback if needed
                          },
                        ),
                      ),
                    );
                  },
                ),
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

                SizedBox(
                  width: double.infinity,
                  child: _isSubmitting
                      ? null // Provide a widget when _isSubmitting is true
                      : CustomButton(
                          baseTextColor: ThemeConstants.whiteColor,
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Failed to save/update address")));
                              }

                              setState(() {
                                _isSubmitting = false;
                              });
                            }
                          },
                          text: widget.flag != "isEdit" ? 'SAVE' : 'UPDATE',
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
