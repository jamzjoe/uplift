import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PostActions extends StatefulWidget {
  const PostActions(
      {super.key,
      required this.prayerRequest,
      required this.currentUser,
      required this.screenshotController,
      required this.userModel,
      required this.postModel,
      required this.isFullView});
  final PrayerRequestPostModel prayerRequest;
  final UserModel currentUser;
  final ScreenshotController screenshotController;
  final UserModel userModel;
  final PostModel postModel;
  final bool isFullView;

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

  int encourageCount = 0;

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.currentUser;
    final postID = widget.prayerRequest.postId;
    int length = widget.prayerRequest.reactions!.users!.length;
    final ScrollController scrollController = ScrollController();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<Map<String, dynamic>>(
          stream: PrayerRequestRepository()
              .getReactionInfo(postID!, currentUser.userId!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            final bool isReacted = snapshot.data!['isReacted'];
            final int reactionCount = snapshot.data!['reactionCount'];
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        isReacted
                            ? addReact(postID, currentUser)
                            : unreact(postID, currentUser);
                      },
                      focusColor: primaryColor,
                      radius: 100,
                      splashColor: primaryColor,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                                !isReacted
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: whiteColor,
                                size: 20),
                            const SizedBox(width: 5),
                            SmallText(
                                text: isReacted ? 'Pray' : 'Prayed',
                                color: whiteColor)
                          ],
                        ),
                      ),
                    ),

                    // Rest of the code
                  ],
                ),
              ],
            );
          },
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            if (widget.isFullView == true) {
              return;
            } else {
              BlocProvider.of<EncourageBloc>(context)
                  .add(FetchEncourageEvent(widget.prayerRequest.postId!));
              CustomDialog().showComment(
                  context,
                  currentUser,
                  widget.postModel.userModel,
                  widget.prayerRequest,
                  widget.postModel);
            }
          },
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.chat_bubble,
                    size: 20,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 10),
                  SmallText(text: 'Encourages', color: lighter)
                ],
              )),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: saveAndShare,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: const Icon(
              Ionicons.share_social_outline,
              size: 20,
              color: primaryColor,
            ),
          ),
        )
      ],
    );
  }

  Future<bool> addReact(String postID, UserModel currentUser) {
    return PrayerRequestRepository().addReaction(
        postID, currentUser.userId!, widget.userModel, currentUser);
  }

  Future<bool> unreact(String postID, UserModel currentUser) {
    return PrayerRequestRepository().unReact(postID, currentUser.userId!);
  }

  Future saveAndShare() async {
    final Uint8List? imageBytes = await widget.screenshotController.capture();
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/uplift.png');
    image.writeAsBytes(imageBytes!);

    await Share.shareFiles([image.path]);
  }

  void checkReaction(
      PrayerRequestPostModel prayerRequest, UserModel currentUser) async {
    Future.delayed(const Duration(microseconds: 1), () {
      PrayerRequestRepository()
          .isReacted(prayerRequest.postId!, currentUser.userId!)
          .then((value) {
        setState(() {
          isReacted = value;
        });
      });
    });
  }
}
