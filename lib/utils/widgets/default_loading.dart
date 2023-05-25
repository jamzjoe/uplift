import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uplift/constant/constant.dart';

class DefaultLoading extends StatelessWidget {
  const DefaultLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitFadingCircle(
        color: primaryColor,
      ),
    );
  }
}
