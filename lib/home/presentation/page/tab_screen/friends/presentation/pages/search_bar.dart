import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    this.controller,
    this.onFieldSubmitted,
    this.hint,
  });
  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(5),
        widget: TextFormField(
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onFieldSubmitted,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(right: 30),
            hintText: hint,
            border: const UnderlineInputBorder(borderSide: BorderSide.none),
            icon: IconButton(
                padding: const EdgeInsets.all(2),
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.search_circle_fill,
                  color: lightColor,
                  size: 30,
                )),
          ),
        ),
        color: lightColor.withOpacity(0.2));
  }
}
