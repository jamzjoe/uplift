import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class TextDateWidget extends StatelessWidget {
  final DateTime date;
  final String? fillers;

  const TextDateWidget({super.key, required this.date, this.fillers});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM dd, yyyy').format(date);

    return SmallText(text: "${fillers ?? ''} $formattedDate", color: lighter);
  }
}
