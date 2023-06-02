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
  @override
  Widget build(BuildContext context) {
    _showBottomSheet(BuildContext context) {
      if (_isBottomSheetVisible) {
        return;
      }
      setState(() {
        _isBottomSheetVisible = true;
      });
      showFlexibleBottomSheet(
        bottomSheetColor: Colors.transparent,
        initHeight: .58,
        maxHeight: 1,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        barrierColor: Colors.transparent,
        duration: Duration(seconds: 1.5.toInt()),
        context: context,
        builder: (context, scrollController, bottomSheetOffset) {
          return const BottomSheetContent();
        },
      );
    }

    // Show the bottom sheet automatically when the page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet(context);
    });

    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
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
