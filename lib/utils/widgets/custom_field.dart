import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';

class CustomField extends StatefulWidget {
  const CustomField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.isPassword,
    this.suffixIcon,
    this.tapSuffix,
    this.hintText,
  });
  final String? label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? isPassword;
  final String? hintText;
  final IconData? suffixIcon;
  final VoidCallback? tapSuffix;

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            obscureText: widget.isPassword ?? false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: widget.controller,
            validator: widget.validator,
            decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(fontWeight: FontWeight.w400),
                suffixIcon: widget.suffixIcon != null
                    ? GestureDetector(
                        onTap: widget.tapSuffix, child: Icon(widget.suffixIcon))
                    : null,
                label: DefaultText(text: widget.label!, color: secondaryColor),
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
          ),
        ],
      ),
    );
  }
}
