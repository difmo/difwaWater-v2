import 'package:difwa/config/app_color.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputType { phone, email, name, address, visiblePassword ,pin}

class CommonTextField extends StatefulWidget {
  final InputType inputType;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String label;
  final String hint;
  final bool readOnly;
  final bool autofocus;
  final double? borderRadius;
  final double? height;
  final Color? borderColor;
  final IconData? icon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator; // Accept a validator function


  const CommonTextField({
    super.key,
    required this.inputType,
    required this.controller,
    required this.onChanged,
    required this.label,
    required this.hint,
    this.readOnly = false,
    this.autofocus = false,
    this.borderRadius,
    this.height,
    this.borderColor,
    this.icon,
    this.suffixIcon,
    this.validator, // Optional validator function
  });

  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late List<TextInputFormatter> _inputFormatters;
  late TextInputType _keyboardType;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _setInputType();
  }

  void _setInputType() {
    _inputFormatters = []; // Ensure initialization
    switch (widget.inputType) {
      case InputType.phone:
        _keyboardType = TextInputType.phone;
        _inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];
        break;
      case InputType.email:
        _keyboardType = TextInputType.emailAddress;
        break;
      case InputType.name:
        _keyboardType = TextInputType.name;
        _inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]")),
        ];
        break;
      case InputType.address:
        _keyboardType = TextInputType.streetAddress;
        break;
      case InputType.visiblePassword:
        _keyboardType = TextInputType.text;
        break;
    

    case InputType.pin:
        _keyboardType = TextInputType.number;
        _inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ];
        break;
        }
  }

  @override
  Widget build(BuildContext context) {
    Color defaultBorderColor = widget.borderColor ?? ThemeConstants.borderColor;

    return TextFormField(
      autofocus: widget.autofocus,
      controller: widget.controller,
      keyboardType: _keyboardType,
      inputFormatters: _inputFormatters,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
      obscureText:
          widget.inputType == InputType.visiblePassword ? _obscureText : false,
      validator: widget.validator, // Apply validation function
      style: TextStyle(
        color:
            widget.readOnly ? Colors.grey : const Color.fromARGB(255, 0, 0, 0),
        letterSpacing: 1.5,
      ),
      decoration: InputDecoration(
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: ThemeConstants.blackColor)
            : null,
        suffixIcon: widget.inputType == InputType.visiblePassword
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: ThemeConstants.blackColor),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : (widget.suffixIcon != null
                ? Icon(widget.suffixIcon, color: ThemeConstants.grey)
                : null),
        labelText: widget.label,
        hintText: widget.hint,
        labelStyle: TextStyle(
          color: widget.readOnly ? Colors.grey : ThemeConstants.borderColor,
          fontWeight: FontWeight.w200,
          fontSize: 16,
        ),
        hintStyle: TextStyle(
          color: widget.readOnly ? Colors.grey : Colors.grey,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: TextStyle(
          color: widget.readOnly ? Colors.grey : ThemeConstants.borderColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? Colors.grey[200]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 16.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.inputfield,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 16.0),
        ),
        contentPadding:
            EdgeInsets.symmetric(vertical: widget.height ?? 0, horizontal: 20),
      ),
    );
  }
}
