import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:difwa/config/app_color.dart';
import 'package:difwa/controller/address_controller.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/utils/validators.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  // Controllers for text fields
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isChecked = false; // Checkbox state

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

  final bool _isSubmitting = false; // State to handle submission progress

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
      body: Padding(
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
                    favorite: const ['+91', '+1'],
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
                hint: 'Enter your street address',
                validator: Validators.validatestreet,
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
                        // You can handle the onChanged callback here if needed
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

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: _isSubmitting
                  ? CircularProgressIndicator()
                  : CustomButton(
                      baseTextColor: ThemeConstants.whiteColor,
                      onPressed: () async {
                        _formKeyName.currentState!.validate();
                        _formKeyPhone.currentState!.validate();
                        _formKeyAddress.currentState!.validate();
                        _formState.currentState!.validate();
                        _formPin.currentState!.validate();
                        _formCity.currentState!.validate();

                        if (_formKeyName.currentState!.validate() &&
                            _formKeyPhone.currentState!.validate() &&
                            _formKeyAddress.currentState!.validate() &&
                            _formState.currentState!.validate() &&
                            _formPin.currentState!.validate() &&
                            _formCity.currentState!.validate()) {
                          await _addressController.saveAddress(
                            _streetController.text,
                            _cityController.text,
                            _stateController.text,
                            _zipController.text,
                            _countryController.text,
                            _phoneController.text,
                            _isChecked,
                          );
                        }
                      },
                      text: 'Submit'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
