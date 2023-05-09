import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/just_now.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/small_text.dart';
import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../utils/widgets/default_text.dart';

class PostItem extends StatefulWidget {
  const PostItem({
    super.key,
    required this.postModel,
    required this.user,
  });
  final PostModel postModel;
  final User user;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  void initState() {
    super.initState();
  }

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final user = widget.postModel.userModel;
    final currentUser = widget.user;
    final prayerRequest = widget.postModel.prayerRequestPostModel;
    return Screenshot(
      controller: screenshotController,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: whiteColor,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Profile, Name and Action Buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                user.photoUrl == null
                    ? const CircleAvatar(
                        backgroundImage: AssetImage('assets/default.png'),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(user.photoUrl!),
                      ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(
                        text: user.displayName ?? 'User',
                        color: secondaryColor,
                        size: 18,
                      ),
                      SmallText(
                          text: DateFeature()
                              .formatDateTime(prayerRequest.date!.toDate()),
                          color: lightColor)
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PopupMenuButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_horiz),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            onTap: () {},
                            child: const ListTile(
                              dense: true,
                              leading: Icon(CupertinoIcons.bookmark_fill),
                              title: DefaultText(
                                  text: 'Save Post', color: secondaryColor),
                            )),
                        PopupMenuItem(
                            onTap: () async {
                              Future.delayed(
                                  const Duration(milliseconds: 300),
                                  () => CustomDialog.showDeleteConfirmation(
                                          context,
                                          'This will delete this prayer request.',
                                          'Delete Confirmation', () async {
                                        context.pop();
                                        final canDelete =
                                            await PrayerRequestRepository()
                                                .deletePost(
                                                    prayerRequest.postId!,
                                                    user.userId!);
                                        if (canDelete) {
                                          if (context.mounted) {
                                            CustomDialog.showSuccessDialog(
                                                context,
                                                'Prayer request deleted successfully!',
                                                'Request Granted',
                                                'Confirm');
                                          }
                                        } else {
                                          if (context.mounted) {
                                            CustomDialog.showErrorDialog(
                                                context,
                                                "You can't delete someone's prayer request.",
                                                'Request Denied',
                                                'Confirm');
                                          }
                                        }
                                      }, 'Delete'));
                            },
                            child: const ListTile(
                              dense: true,
                              leading: Icon(CupertinoIcons.delete_left_fill),
                              title: DefaultText(
                                  text: 'Delete Post', color: secondaryColor),
                            ))
                      ],
                    ),
                  ],
                )
              ],
            ),
            defaultSpace,
            DefaultText(text: prayerRequest.text!, color: secondaryColor),
            defaultSpace,

            //Likes and Views Count
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundImage: AssetImage('assets/default.png'),
                    ),
                    const SizedBox(width: 5),
                    SmallText(
                        text:
                            "${prayerRequest.reactions!.users!.length} is praying for you.",
                        color: lightColor)
                  ],
                ),
              ],
            ),

            const Divider(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder(
                    future: PrayerRequestRepository()
                        .isReacted(prayerRequest.postId!, currentUser.uid),
                    builder: (context, _) {
                      if (_.hasData) {
                        if (_.data == false) {
                          return PrayedButton(
                              prayerRequest: prayerRequest,
                              currentUser: currentUser,
                              path: "assets/prayed.png",
                              label: 'Prayed');
                        } else {
                          return PrayedButton(
                              prayerRequest: prayerRequest,
                              currentUser: currentUser,
                              path: "assets/unprayed.png",
                              label: 'Pray');
                        }
                      }
                      return PrayedButton(
                          prayerRequest: prayerRequest,
                          currentUser: currentUser,
                          path: "assets/unprayed.png",
                          label: 'Pray');
                    }),
                TextButton.icon(
                    onPressed: () async {
                      Share.share(prayerRequest.text!);
                      log(prayerRequest.date!.toDate().toString());
                    },
                    icon: const Image(
                      image: AssetImage('assets/share.png'),
                      width: 30,
                    ),
                    label: SmallText(
                      text: 'Share',
                      color: secondaryColor.withOpacity(0.8),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String> saveImage(Uint8List bytes) async {
    try {
      final result = await ImageGallerySaver.saveImage(bytes);
      log(result['filepath'].toString());
      return result['filepath'];
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }
}

class PrayedButton extends StatelessWidget {
  const PrayedButton({
    super.key,
    required this.prayerRequest,
    required this.currentUser,
    required this.path,
    required this.label,
  });

  final PrayerRequestPostModel prayerRequest;
  final User currentUser;
  final String path;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () {
          prayerRequestRepository.addReaction(
              prayerRequest.postId!, currentUser.uid);
        },
        icon: Image(
          image: AssetImage(path),
          width: 30,
        ),
        label: SmallText(text: label, color: secondaryColor.withOpacity(0.8)));
  }
}
