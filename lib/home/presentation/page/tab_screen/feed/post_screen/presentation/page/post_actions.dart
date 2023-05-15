import 'dart:developer';
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

class PostActions extends StatelessWidget {
  const PostActions(
      {super.key,
      required this.prayerRequest,
      required this.currentUser,
      required this.screenshotController});
  final PrayerRequestPostModel prayerRequest;
  final User currentUser;
  final ScreenshotController screenshotController;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            FutureBuilder(
                future: PrayerRequestRepository()
                    .isReacted(prayerRequest.postId!, currentUser.uid),
                builder: (context, isReacted) {
                  log(isReacted.toString());
                  if (isReacted.connectionState == ConnectionState.waiting) {
                    return LikeButton(
                      likeCountPadding: EdgeInsets.zero,
                      size: 50,
                      likeCount: prayerRequest.reactions!.users!.length,
                      likeBuilder: (isLiked) => PrayedButton(
                        prayerRequest: prayerRequest,
                        currentUser: currentUser,
                        path: "assets/prayed.png",
                        label: '',
                      ),
                    );
                  }
                  if (isReacted.hasData) {
                    bool? isReact = isReacted.data ?? true;
                    return LikeButton(
                      isLiked: !isReact,
                      likeCount: prayerRequest.reactions!.users!.length,
                      onTap: (isLiked) {
                        if (isLiked) {
                          return PrayerRequestRepository()
                              .unReact(prayerRequest.postId!, currentUser.uid);
                        } else {
                          return PrayerRequestRepository().addReaction(
                              prayerRequest.postId!, currentUser.uid);
                        }
                      },
                      likeCountAnimationType: LikeCountAnimationType.all,
                      likeCountPadding: EdgeInsets.zero,
                      likeBuilder: (isLiked) {
                        return PrayedButton(
                            prayerRequest: prayerRequest,
                            currentUser: currentUser,
                            path: isLiked
                                ? "assets/prayed.png"
                                : "assets/unprayed.png",
                            label: 'Prayed');
                      },
                      size: 50,
                    );
                  } else {
                    return PrayedButton(
                      prayerRequest: prayerRequest,
                      currentUser: currentUser,
                      path: "assets/prayed.png",
                      label: '',
                    );
                  }
                }),
            IconButton(
                onPressed: () async {
                  // final image = await saveImage();
                  saveAndShare();
                },
                icon: const Icon(CupertinoIcons.arrowshape_turn_up_right,
                    size: 22)),
          ],
        ),
        IconButton(
            onPressed: () async {
              // final image = await saveImage();
              saveAndShare();
            },
            icon: const Icon(
              CupertinoIcons.bookmark,
              size: 20,
              color: secondaryColor,
            ))
      ],
    );
  }

  void saveAndShare() async {
    final Uint8List? imageBytes = await screenshotController.capture();
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/uplift.png');
    image.writeAsBytes(imageBytes!);

    await Share.shareFiles([image.path]);
  }
}
