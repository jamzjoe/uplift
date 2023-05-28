import 'dart:io';

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    LikeButton(
                        onTap: (isLiked) async {
                          if (isLiked) {
                            unreact(postID, currentUser);
                            return isLiked = !isLiked;
                          } else {
                            addReact(postID, currentUser);
                            return isLiked = !isLiked;
                          }
                        },
                        padding: EdgeInsets.zero,
                        likeCountPadding: EdgeInsets.zero,
                        isLiked: !isReacted,
                        size: 30,
                        likeBuilder: (isLiked) => PrayedButton(
                              path: isReacted
                                  ? "assets/unprayed.png"
                                  : "assets/prayed.png",
                            )
                        // Rest of the code
                        ),
                    const SizedBox(width: 10),
                    isReacted
                        ? GestureDetector(
                            onTap: () => addReact(postID, currentUser),
                            child: SmallText(text: 'Pray', color: lighter))
                        : GestureDetector(
                            onTap: () => unreact(postID, currentUser),
                            child: SmallText(text: 'Prayed', color: lighter))
                    // Rest of the code
                  ],
                ),
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
                CustomDialog().showComment(
                    context,
                    currentUser,
                    widget.postModel.userModel,
                    widget.prayerRequest,
                    widget.postModel);
              }
            },
            icon: Icon(
              CupertinoIcons.chat_bubble,
              size: 22,
              color: lighter,
            ),
            label: SmallText(text: 'Encourage', color: lighter)),
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
