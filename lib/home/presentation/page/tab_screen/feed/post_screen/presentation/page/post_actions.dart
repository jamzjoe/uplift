import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PostActions extends StatefulWidget {
  const PostActions(
      {super.key,
      required this.prayerRequest,
      required this.currentUser,
      required this.screenshotController});
  final PrayerRequestPostModel prayerRequest;
  final User currentUser;
  final ScreenshotController screenshotController;

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  bool isReacted = false;
  @override
  void initState() {
    checkReaction(widget.prayerRequest, widget.currentUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.currentUser;
    final postID = widget.prayerRequest.postId;
    int length = widget.prayerRequest.reactions!.users!.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LikeButton(
              isLiked: !isReacted,
              likeCountPadding: EdgeInsets.zero,
              size: 50,
              onTap: (isLiked) async {
                if (!isLiked) {
                  PrayerRequestRepository()
                      .addReaction(postID!, currentUser.uid);
                  setState(() {
                    isReacted = !isReacted;
                    length++;
                  });
                  return isLiked = true;
                } else {
                  PrayerRequestRepository().unReact(postID!, currentUser.uid);
                  setState(() {
                    isReacted = !isReacted;
                    length--;
                  });
                  return isLiked = false;
                }
              },
              likeCount: length,
              likeBuilder: (isLiked) => PrayedButton(
                    prayerRequest: widget.prayerRequest,
                    currentUser: widget.currentUser,
                    path:
                        isReacted ? "assets/unprayed.png" : "assets/prayed.png",
                    label: '',
                  )),
          const SizedBox(width: 10),
          TextButton.icon(
              label: const SmallText(text: 'Share', color: secondaryColor),
              onPressed: () async {
                // final image = await saveImage();
                saveAndShare();
              },
              icon: const Icon(
                CupertinoIcons.arrowshape_turn_up_right,
                size: 22,
                color: secondaryColor,
              )),
          const SizedBox(width: 10),
          TextButton.icon(
              label: const SmallText(text: 'Save', color: secondaryColor),
              onPressed: () async {
                // final image = await saveImage();
                saveAndShare();
              },
              icon: const Icon(
                CupertinoIcons.bookmark,
                size: 22,
                color: secondaryColor,
              )),
        ],
      ),
    );
  }

  void saveAndShare() async {
    final Uint8List? imageBytes = await widget.screenshotController.capture();
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/uplift.png');
    image.writeAsBytes(imageBytes!);

    await Share.shareFiles([image.path]);
  }

  void checkReaction(
      PrayerRequestPostModel prayerRequest, User currentUser) async {
    Future.delayed(const Duration(microseconds: 1), () {
      PrayerRequestRepository()
          .isReacted(prayerRequest.postId!, currentUser.uid)
          .then((value) {
        setState(() {
          isReacted = value;
        });
      });
    });
  }
}
