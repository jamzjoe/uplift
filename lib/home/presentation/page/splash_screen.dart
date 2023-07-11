import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uplift/constant/constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              SpinKitRipple(
                color: whiteColor,
                size: 200,
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: Center(
                  child: Image(
                    image: AssetImage('assets/uplift-logo-white.png'),
                    width: 80,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
