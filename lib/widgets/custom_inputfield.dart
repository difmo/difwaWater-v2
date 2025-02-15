import 'package:difwa/utils/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputType { phone, email, name, address, visiblePassword }

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
      case InputType.visiblePassword:
        _keyboardType = TextInputType.text;
        break;
    }
  }

  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '${widget.label} is required';
    }
    switch (widget.inputType) {
      case InputType.phone:
        if (value.length != 10) return 'Enter a valid 10-digit phone number';
        break;
      case InputType.email:
        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(value)) {
          return 'Enter a valid email address';
        }
        break;
      case InputType.name:
        if (value.length < 2) return 'Enter a valid name';
        break;
      case InputType.address:
        if (value.length < 5) return 'Enter a valid address';
        break;
      case InputType.visiblePassword:
        String passwordPattern =
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

        if (!RegExp(passwordPattern).hasMatch(value)) {
          return 'Password must be at least 8 characters, include an uppercase letter, a lowercase letter, a number, and a special character';
        }
        break;
    }
    return null;
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
      validator: _validateInput,
      obscureText:
          widget.inputType == InputType.visiblePassword ? _obscureText : false,
      style: TextStyle(
        color:
            widget.readOnly ? Colors.grey : const Color.fromARGB(255, 0, 0, 0),
        letterSpacing: 1.5,
      ),
      decoration: InputDecoration(
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: ThemeConstants.grey)
            : null,
        suffixIcon: widget.inputType == InputType.visiblePassword
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: ThemeConstants.grey),
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
            color: widget.borderColor ?? Colors.grey[100]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 16.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: defaultBorderColor,
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
