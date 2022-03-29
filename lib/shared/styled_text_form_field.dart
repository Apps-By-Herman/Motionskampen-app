import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class StyledTextFormField extends StatelessWidget {
  StyledTextFormField({
    required this.controller,
    required this.keyboardType,
    required this.labelText,
    this.validator,
    this.maxLength,
    this.obscureText = false,
    this.inputFormatter,
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String? Function(String? value)? validator;
  final int? maxLength;
  final bool obscureText;
  final FilteringTextInputFormatter? inputFormatter;

  @override
  Widget build(BuildContext context) {
    final _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Theme.of(context).accentColor,
        width: 3,
      ),
    );

    final _errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.red,
        width: 3,
      ),
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      inputFormatters: [
        inputFormatter ?? FilteringTextInputFormatter.singleLineFormatter
      ],
      style: TextStyle(color: Theme.of(context).accentColor),
      validator: validator,
      decoration: InputDecoration(
        counterStyle: TextStyle(color: Theme.of(context).accentColor),
        errorStyle: TextStyle(color: Theme.of(context).accentColor),
        labelText: labelText,
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        enabledBorder: _border,
        focusedBorder: _border,
        errorBorder: _errorBorder,
        focusedErrorBorder: _errorBorder,
      ),
    );
  }
}
