import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_actions.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_text.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/post_photo_viewer.dart';
import 'package:uplift/utils/widgets/small_text.dart';
import '../../../../../../../../constant/constant.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'post_header.dart';

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

  int imageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final user = widget.postModel.userModel;
    final currentUser = widget.user;
    final prayerRequest = widget.postModel.prayerRequestPostModel;
    final length = prayerRequest.imageUrls!.length;
    return Screenshot(
      controller: screenshotController,
      child: Container(
        decoration: const BoxDecoration(
            color: whiteColor,
            border: Border(bottom: BorderSide(width: 0.5, color: lightColor))),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Profile, Name and Action Buttons
            PostHeader(user: user, prayerRequest: prayerRequest),
            const SizedBox(height: 5),
            prayerRequest.imageUrls!.isEmpty
                ? const SizedBox()
                : prayerRequest.imageUrls!.length == 1
                    ? PostPhotoViewer(path: prayerRequest.imageUrls!.first)
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
                                  autoPlayInterval: const Duration(seconds: 8),
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                children: [
                  PostActions(
                    prayerRequest: prayerRequest,
                    currentUser: currentUser,
                    screenshotController: screenshotController,
                    userModel: user,
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
        onPressed: null,
        icon: Image(
          image: AssetImage(path),
          width: 30,
        ));
  }
}
