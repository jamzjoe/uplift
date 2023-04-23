import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';

class CustomField extends StatefulWidget {
  const CustomField({
    super.key,
    required this.label,
  });
  final String label;

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
