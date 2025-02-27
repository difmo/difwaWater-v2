import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/utils/validators.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AddressPage());
}

class AddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Address Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddressForm(),
    );
  }
}

class AddressForm extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  // late AnimationController _staggeredController;
  // late List<Interval> _itemSlideIntervals;
  // late Interval _buttonInterval;
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String selectedCountryCode = "+91"; // Default country code
  Country? selectedCountry; // To store the selected country

  final _formKeyName = GlobalKey<FormState>();
  final _formKeyPhone = GlobalKey<FormState>();
  final _formKeyAddress = GlobalKey<FormState>();
  final _formPin = GlobalKey<FormState>();
  final _formState = GlobalKey<FormState>();
  final _formCity = GlobalKey<FormState>();

  // Submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, you can process the data
      print("Full Name: ${_nameController.text}");
      print("Phone: ${_phoneController.text}");
      print("Street: ${_streetController.text}");
      print("City: ${_cityController.text}");
      print("State: ${_stateController.text}");
      print("ZIP: ${_zipController.text}");
      print("Country: ${_countryController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.whiteColor,
      appBar: AppBar(
        backgroundColor: ThemeConstants.whiteColor,
        title: Text('Checkout'),
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
                hint: 'Enter your street address',
                validator: Validators.validatestreet,
              ),
            ),
            SizedBox(height: 20),

            // // City
            // Form(
            //   child: CommonTextField(
            //     inputType: InputType.name,
            //     controller: _cityController,
            //     onChanged: (value) {},
            //     label: 'City',
            //     hint: 'Enter your city',
            //     validator: Validators.validateName,
            //   ),
            // ),
            // SizedBox(height: 16),

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
                validator: Validators.validateName,
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
                      validator: Validators.validateName,
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
                      validator: Validators.validateName,
                      onChanged: (String value) {
                        // You can handle the onChanged callback here if needed
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                  baseTextColor: ThemeConstants.whiteColor,
                  onPressed: _submitForm,
                  text: 'Submit'),
            )
          ],
        ),
      ),
    );
  }
}
