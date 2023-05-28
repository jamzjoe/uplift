import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/comment_view.dart';
import '../../home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_feed.dart';

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

  Future<dynamic> showComment(BuildContext context, UserModel currentUser, UserModel userModel, PrayerRequestPostModel prayerRequestPostModel, PostModel postModel){
    return showFlexibleBottomSheet(
                          minHeight: 0,
                          isExpand: true,
                          isDismissible: true,
                          isCollapsible: true,
                          isModal: true,
                          initHeight: 0.92,
                          maxHeight: 1,
                          context: context,
                          builder:
                              (context, scrollController, bottomSheetOffset) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [], // Remove the shadow by using an empty list of BoxShadow
                              ),
                              child: CommentView(
                                currentUser: currentUser,
                                prayerRequestPostModel: prayerRequestPostModel,
                                postOwner: userModel,
                                postModel: postModel,
                                scrollController: scrollController,
                              ),
                            );
                          },
                          anchors: [0, 0.5, 1],
                          isSafeArea: true,
                        );
  }

  Future<dynamic> showProfile(
      BuildContext context, UserModel currentUser, UserModel userModel) {
    return showFlexibleBottomSheet(
      minHeight: 0,
      initHeight: 0.92,
      maxHeight: 1,
      context: context,
      builder: (context, scrollController, bottomSheetOffset) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [], // Remove the shadow by using an empty list of BoxShadow
          ),
          child: FriendsFeed(
            userModel: userModel,
            currentUser: currentUser,
            scrollController: scrollController,
          ),
        );
      },
      anchors: [0, 0.5, 1],
      isSafeArea: true,
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
