import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';

class CustomField extends StatefulWidget {
  const CustomField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
  });
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
          label: DefaultText(text: widget.label, color: secondaryColor),
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: primaryColor.withOpacity(0.20),
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: primaryColor.withOpacity(0.80),
          )),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: primaryColor.withOpacity(0.20),
          ))),
    );
  }
}
