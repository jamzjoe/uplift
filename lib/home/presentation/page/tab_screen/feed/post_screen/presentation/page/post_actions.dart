import 'dart:io';

import 'package:bottom_sheet/bottom_sheet.dart';
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<Map<String, dynamic>>(
          stream: getReactionInfo(postID!, currentUser.userId!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final bool isReacted = snapshot.data!['isReacted'];
            final int reactionCount = snapshot.data!['reactionCount'];
            return Row(
              children: [
                LikeButton(
                    onTap: (isLiked) async {
                      if (isLiked) {
                        PrayerRequestRepository()
                            .unReact(postID, currentUser.userId!);
                        return isLiked = !isLiked;
                      } else {
                        PrayerRequestRepository().addReaction(postID,
                            currentUser.userId!, widget.userModel, currentUser);
                        return isLiked = !isLiked;
                      }
                    },
                    padding: EdgeInsets.zero,
                    likeCountPadding: EdgeInsets.zero,
                    isLiked: !isReacted,
                    likeCount: reactionCount,
                    size: 30,
                    likeBuilder: (isLiked) => PrayedButton(
                          path: isReacted
                              ? "assets/unprayed.png"
                              : "assets/prayed.png",
                        )
                    // Rest of the code
                    ),
                // Rest of the code
              ],
            );
          },
        ),
        const SizedBox(width: 10),
        TextButton.icon(
            onPressed: () {
              if (widget.isFullView == true) {
                return;
              } else {
                BlocProvider.of<EncourageBloc>(context)
                    .add(FetchEncourageEvent(widget.prayerRequest.postId!));
                showFlexibleBottomSheet(
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
                      child: CommentView(
                        currentUser: widget.currentUser,
                        prayerRequestPostModel: widget.prayerRequest,
                        postOwner: widget.userModel,
                        postModel: widget.postModel,
                        scrollController: scrollController,
                      ),
                    );
                  },
                  anchors: [0, 0.5, 1],
                  isSafeArea: true,
                );
              }
            },
            icon: Icon(
              CupertinoIcons.chat_bubble,
              size: 22,
              color: lighter,
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
                      text: '${snapshot.data!.size} Encourage', color: lighter);
                })),
        const SizedBox(width: 10),
        TextButton.icon(
            label: SmallText(text: 'Share', color: lighter),
            onPressed: () async {
              // final image = await saveImage();

              saveAndShare();
            },
            icon: Icon(
              CupertinoIcons.arrowshape_turn_up_right,
              size: 22,
              color: lighter,
            )),
      ],
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

  Stream<Map<String, dynamic>> getReactionInfo(String postID, String userID) {
    return FirebaseFirestore.instance
        .collection('Prayers')
        .doc(postID)
        .snapshots()
        .map((snapshot) {
      final List<dynamic> currentReactions =
          snapshot.data()!['reactions']['users'];
      bool userExist = false;
      for (var reaction in currentReactions) {
        if (reaction is Map && reaction.containsKey(userID)) {
          userExist = true;
        }
      }
      final int reactionCount = currentReactions.length;
      return {
        'isReacted': !userExist,
        'reactionCount': reactionCount,
      };
    }).handleError((error) {
      // Handle error if necessary
      return {
        'isReacted': false,
        'reactionCount': 0,
      };
    });
  }
}
