import 'dart:developer';
import 'dart:typed_data';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_actions.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/comment_view.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_text.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/post_photo_viewer.dart';
import 'package:uplift/utils/widgets/small_text.dart';
import '../../../../../../../../constant/constant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'post_header.dart';

class PostItem extends StatefulWidget {
  const PostItem({
    super.key,
    required this.postModel,
    required this.user,
    this.fullView,
  });
  final PostModel postModel;
  final UserModel user;
  final bool? fullView;

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
  final ScrollController scrollController = ScrollController();

  int imageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final user = widget.postModel.userModel;
    final currentUser = widget.user;
    final prayerRequest = widget.postModel.prayerRequestPostModel;
    final length = prayerRequest.imageUrls!.length;
    return Screenshot(
      controller: screenshotController,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: widget.fullView! ? 0 : 2.5),
        child: Container(
          decoration: BoxDecoration(
              color: whiteColor,
              border: Border(
                  bottom: BorderSide(
                      width: 0.5, color: lightColor.withOpacity(0.2)))),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Profile, Name and Action Buttons
                PostHeader(
                    user: user,
                    prayerRequest: prayerRequest,
                    currentUser: currentUser),
                prayerRequest.imageUrls!.isEmpty
                    ? const SizedBox()
                    : prayerRequest.imageUrls!.length == 1
                        ? PostPhotoViewer(
                            path: prayerRequest.imageUrls!.first,
                            radius: 0,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  CarouselSlider(
                                    items: [
                                      ...prayerRequest.imageUrls!
                                          .map((e) => PostPhotoViewer(path: e))
                                    ],
                                    options: CarouselOptions(
                                      height: 400,
                                      pauseAutoPlayOnTouch: true,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 0.8,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          imageIndex = index;
                                        });
                                      },
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: false,
                                      autoPlayInterval:
                                          const Duration(seconds: 8),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      enlargeFactor: 0.13,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ),
                                  Positioned(
                                    right: 15,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: secondaryColor.withOpacity(0.7),
                                      ),
                                      child: SmallText(
                                          text: '${imageIndex + 1}/$length',
                                          color: whiteColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                children: List.generate(
                                    prayerRequest.imageUrls!.length,
                                    (index) => Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: CircleAvatar(
                                            radius: 3,
                                            backgroundColor: index == imageIndex
                                                ? primaryColor
                                                : lightColor,
                                          ),
                                        )).toList(),
                              )
                            ],
                          ),

                PostText(prayerRequest: prayerRequest),
                //Likes and Views Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<Map<String, dynamic>>(
                        stream: PrayerRequestRepository().getReactionInfo(
                            prayerRequest.postId!, currentUser.userId!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final bool isReacted = snapshot.data!['isReacted'];
                            final int reactionCount =
                                snapshot.data!['reactionCount'];
                            return Visibility(
                              visible: reactionCount != 0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Image(
                                      image: AssetImage('assets/prayed.png'),
                                      width: 20),
                                  SmallText(
                                      text: getReactionText(
                                          isReacted, reactionCount),
                                      color: lighter),
                                ],
                              ),
                            );
                          }
                          return const SizedBox();
                        }),
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<EncourageBloc>(context)
                            .add(FetchEncourageEvent(prayerRequest.postId!));
                        showFlexibleBottomSheet(
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
                                prayerRequestPostModel: prayerRequest,
                                postOwner: user,
                                postModel: widget.postModel,
                                scrollController: scrollController,
                              ),
                            );
                          },
                          anchors: [0, 0.5, 1],
                          isSafeArea: true,
                        );
                      },
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('Comments')
                              .where('post_id', isEqualTo: prayerRequest.postId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                children: [
                                  Icon(CupertinoIcons.chat_bubble,
                                      color: lighter, size: 15),
                                  SmallText(
                                      text: snapshot.data!.size <= 1
                                          ? ' ${snapshot.data!.size} encourage'
                                          : ' ${snapshot.data!.size} encourages',
                                      color: lighter),
                                ],
                              );
                            }
                            return const SizedBox();
                          }),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 0.5,
                ),
                PostActions(
                  isFullView: widget.fullView!,
                  prayerRequest: prayerRequest,
                  currentUser: currentUser,
                  screenshotController: screenshotController,
                  userModel: user,
                  postModel: widget.postModel,
                ),
              ],
            ),
          ),
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

      isLiked = !isReacted;
    });
  }

  String getReactionText(bool isReacted, int reactionCount) {
    if (!isReacted && reactionCount == 1) {
      return 'You prayed this';
    } else if (!isReacted && reactionCount > 1) {
      if (reactionCount >= 1000) {
        // Convert count to "k" format
        final int countInK = (reactionCount / 1000).round();
        return 'You and $countInK k other prayed this';
      } else {
        final count = reactionCount - 1;
        return 'You and $count ${count == 1 ? 'other' : 'others'} prayed this';
      }
    } else {
      if (reactionCount >= 1000) {
        // Convert count to "k" format
        final int countInK = (reactionCount / 1000).round();
        return '$countInK k prayed this';
      } else {
        return '$reactionCount prayed this';
      }
    }
  }
}

class PrayedButton extends StatelessWidget {
  const PrayedButton({
    super.key,
    required this.path,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(path),
      width: 30,
    );
  }
}
