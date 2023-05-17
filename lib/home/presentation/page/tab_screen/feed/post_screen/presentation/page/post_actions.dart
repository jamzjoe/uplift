import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import 'post_comment/presentation/comment_view.dart';

class PostActions extends StatefulWidget {
  const PostActions(
      {super.key,
      required this.prayerRequest,
      required this.currentUser,
      required this.screenshotController,
      required this.userModel,
      required this.postModel});
  final PrayerRequestPostModel prayerRequest;
  final UserModel currentUser;
  final ScreenshotController screenshotController;
  final UserModel userModel;
  final PostModel postModel;

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LikeButton(
            isLiked: !isReacted,
            likeCountPadding: EdgeInsets.zero,
            size: 50,
            onTap: (isLiked) async {
              if (!isLiked) {
                PrayerRequestRepository().addReaction(postID!,
                    currentUser.userId!, widget.userModel, currentUser);
                setState(() {
                  isReacted = !isReacted;
                  length++;
                });
                return isLiked = true;
              } else {
                PrayerRequestRepository().unReact(postID!, currentUser.userId!);
                setState(() {
                  isReacted = !isReacted;
                  length--;
                });
                return isLiked = false;
              }
            },
            likeCount: length,
            likeBuilder: (isLiked) => PrayedButton(
                  path: isReacted ? "assets/unprayed.png" : "assets/prayed.png",
                )),
        const SizedBox(width: 10),
        TextButton.icon(
            onPressed: () {
              showComment(context, widget.userModel, widget.prayerRequest,
                  widget.currentUser);
            },
            icon: const Icon(
              CupertinoIcons.chat_bubble,
              size: 22,
              color: secondaryColor,
            ),
            label: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Comments')
                    .where('post_id', isEqualTo: postID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SmallText(text: '0', color: secondaryColor);
                  }
                  return SmallText(
                      text: '${snapshot.data!.size} Encourage',
                      color: secondaryColor);
                })),
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
      ],
    );
  }

  Future<dynamic> showComment(BuildContext context, UserModel user,
      PrayerRequestPostModel prayerRequestPostModel, UserModel currentUser) {
    BlocProvider.of<EncourageBloc>(context)
        .add(FetchEncourageEvent(widget.prayerRequest.postId!));
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return CommentView(
            postUser: user,
            prayerRequestPostModel: prayerRequestPostModel,
            currentUser: currentUser);
      },
    );
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
