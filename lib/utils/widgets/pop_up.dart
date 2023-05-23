import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class CustomDialog {
  static void showDeleteConfirmation(BuildContext context, String message,
      String title, VoidCallback successFunction, String successButtonText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            color: whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(
                  image: AssetImage('assets/error.png'),
                  width: 60,
                ),
                defaultSpace,
                HeaderText(text: title, color: lighter),
                SmallText(text: message, color: lighter),
                defaultSpace,
                defaultSpace,
                Flexible(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(width: .5, color: lighter),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: lighter,
                                    size: 18,
                                  ),
                                  SmallText(text: 'Cancel', color: lighter),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: successFunction,
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Icon(
                                      Icons.delete_outline,
                                      color: whiteColor,
                                      size: 18,
                                    ),
                                    SmallText(
                                        text: 'Delete', color: whiteColor),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: SmallText(text: message, color: whiteColor)));
  }

  static void showLogoutConfirmation(BuildContext context, String message,
      String title, VoidCallback successFunction, String successButtonText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            color: whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(
                  image: AssetImage('assets/error.png'),
                  width: 60,
                ),
                defaultSpace,
                HeaderText(text: title, color: lighter),
                SmallText(text: message, color: lighter),
                defaultSpace,
                defaultSpace,
                Flexible(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(width: .5, color: lighter),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: lighter,
                                    size: 18,
                                  ),
                                  SmallText(text: 'Cancel', color: lighter),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: successFunction,
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Icon(
                                      Icons.exit_to_app,
                                      color: whiteColor,
                                      size: 18,
                                    ),
                                    SmallText(
                                        text: 'Logout', color: whiteColor),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void showSuccessDialog(BuildContext context, String message,
      String title, String successButtonText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            color: whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(
                  image: AssetImage('assets/success.png'),
                  width: 60,
                ),
                defaultSpace,
                HeaderText(text: title, color: lighter),
                SmallText(text: message, color: lighter),
                defaultSpace,
                defaultSpace,
                Flexible(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xff00A355),
                              ),
                              child: Center(
                                child: SmallText(
                                    text: successButtonText, color: whiteColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, String message,
      String title, String successButtonText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            color: whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(
                  image: AssetImage('assets/error.png'),
                  width: 60,
                ),
                defaultSpace,
                HeaderText(text: title, color: lighter),
                SmallText(
                  text: message,
                  color: lighter,
                  textAlign: TextAlign.center,
                ),
                defaultSpace,
                defaultSpace,
                Flexible(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: SmallText(
                                    text: successButtonText, color: whiteColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void showCustomDialog(BuildContext context, Widget widget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(color: whiteColor, child: widget),
        );
      },
    );
  }
}
