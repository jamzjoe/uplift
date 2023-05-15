import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_actions.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_text.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/just_now.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/post_photo_viewer.dart';
import 'package:uplift/utils/widgets/small_text.dart';
import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../utils/widgets/default_text.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  bool isLiked = false;
  @override
  void initState() {
    readReaction();
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
        decoration: const BoxDecoration(
            color: whiteColor,
            border: Border(bottom: BorderSide(width: 0.5, color: lightColor))),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Profile, Name and Action Buttons
            PostHeader(user: user, prayerRequest: prayerRequest),
            prayerRequest.imageUrls!.isEmpty
                ? const SizedBox()
                : CarouselSlider(
                    items: [
                      ...prayerRequest.imageUrls!
                          .map((e) => PostPhotoViewer(path: e))
                    ],
                    options: CarouselOptions(
                      height: 400,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.2,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),

            //Likes and Views Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  PostText(prayerRequest: prayerRequest),
                  defaultSpace,
                  PostActions(
                    prayerRequest: prayerRequest,
                    currentUser: currentUser,
                    screenshotController: screenshotController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> saveImage() async {
    await [Permission.storage].request();
    try {
      final Uint8List? imageBytes = await screenshotController.capture();
      final result = await ImageGallerySaver.saveImage(imageBytes!,
          name: 'screenshot${DateTime.now()}');
      final filepath = result['filePath'] ?? '';
      log(filepath);
      return filepath;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  void readReaction() {
    Future.delayed(const Duration(seconds: 1), () async {
      final isReacted = await PrayerRequestRepository().isReacted(
          widget.postModel.prayerRequestPostModel.postId!,
          await AuthServices.userID());
      setState(() {
        isLiked = !isReacted;
      });
    });
  }
}

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.user,
    required this.prayerRequest,
  });

  final UserModel user;
  final PrayerRequestPostModel prayerRequest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          user.photoUrl == null
              ? const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/default.png'),
                )
              : CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(user.photoUrl!),
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(
                  text: prayerRequest.name ?? user.displayName ?? 'User',
                  color: secondaryColor,
                  size: 16,
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
                icon: const Icon(
                  CupertinoIcons.ellipsis_vertical,
                  size: 15,
                  color: secondaryColor,
                ),
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
                                          .deletePost(prayerRequest.postId!,
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
    );
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
    return IconButton(
        // onPressed: () async {
        //   await AudioPlayer().play(AssetSource('react.mp3'));
        //   if (label == 'Pray') {
        //     prayerRequestRepository.addReaction(
        //         prayerRequest.postId!, currentUser.uid);
        //   } else {
        //     prayerRequestRepository.unReact(
        //         prayerRequest.postId!, currentUser.uid);
        //   }
        // },
        onPressed: null,
        icon: Image(
          image: AssetImage(path),
          width: 30,
        ));
  }
}
