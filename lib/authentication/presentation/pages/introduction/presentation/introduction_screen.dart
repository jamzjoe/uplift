import 'dart:async';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/authentication/presentation/domain/introduction_repository.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  bool _isBottomSheetVisible = false;
  List<String> images = [
    'assets/bg1.png',
    'assets/bg2.jpg',
    'assets/bg3.jpg',
  ];
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % images.length;
      });
    });

    // Show the bottom sheet automatically when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet(context);
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  void _showBottomSheet(BuildContext context) {
    if (_isBottomSheetVisible) {
      return;
    }
    setState(() {
      _isBottomSheetVisible = true;
    });
    showFlexibleBottomSheet(
      bottomSheetColor: Colors.transparent,
      initHeight: .50,
      maxHeight: 1,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      barrierColor: Colors.transparent,
      duration: const Duration(seconds: 1),
      context: context,
      builder: (context, scrollController, bottomSheetOffset) {
        return const BottomSheetContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 2),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Container(
              key: ValueKey<String>(images[currentIndex]),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(images[currentIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({
    super.key,
  });

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, -2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: CustomContainer(
                widget: const SizedBox(),
                color: primaryColor.withOpacity(0.5),
                width: 70),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(
                        size: 30,
                        text: 'Spreading Light,\nOne Prayer at a Time',
                        color: lighter),
                    defaultSpace,
                    SmallText(
                        text:
                            'The "Uplift" app is a transformative mobile platform designed to create a sacred space for the members of the Missionary Families of Christ community.',
                        color: lighter),
                  ],
                ),
                defaultSpace,
                Center(
                  child: CustomContainer(
                      widget: TextButton.icon(
                          onPressed: () async {
                            IntroductionRepository().googleLogin(context);
                          },
                          icon: const Icon(Ionicons.logo_google,
                              color: whiteColor),
                          label: const SmallText(
                              text: "Sign-in with google", color: whiteColor)),
                      color: primaryColor),
                ),
                Center(
                    child: TextButton(
                        onPressed: () {
                          IntroductionRepository().goToLogin();
                        },
                        child: const SmallText(
                            text: "Continue another way",
                            color: primaryColor))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
