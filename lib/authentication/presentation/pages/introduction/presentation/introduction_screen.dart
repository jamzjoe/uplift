import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/authentication/presentation/domain/introduction_repository.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/create_account_button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/google_button.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  static GlobalKey<IntroductionScreenState> screenKey =
      GlobalKey<IntroductionScreenState>();

  @override
  IntroductionScreenState createState() => IntroductionScreenState();
}

class IntroductionScreenState extends State<IntroductionScreen> {
  List<String> images = [
    'assets/bg1.jpg',
    'assets/bg2.png',
    'assets/bg3.png',
  ];
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % images.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      closeOnBackButton: true,
      child: Scaffold(
        key: IntroductionScreen.screenKey,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: Container(
                  key: ValueKey<String>(images[currentIndex]),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    image: DecorationImage(
                      alignment: AlignmentDirectional.topCenter,
                      image: AssetImage(images[currentIndex]),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height / 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: const BottomSheetContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
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
                    DefaultText(
                        overflow: TextOverflow.fade,
                        text:
                            'The "Uplift" app is a transformative mobile platform designed to create a sacred space for the members of the Missionary Families of Christ community.',
                        color: lighter),
                  ],
                ),
                defaultSpace,
                const GoogleButton(),
                const CreateAccountButton(goTo: 'login',),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

