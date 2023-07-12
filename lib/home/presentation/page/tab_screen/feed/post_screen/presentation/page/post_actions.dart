import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/utils/services/dynamic_links.dart';
import 'package:uplift/utils/widgets/animated_pop_up_heart.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PostActions extends StatefulWidget {
  const PostActions({
    Key? key,
    required this.prayerRequest,
    required this.currentUser,
    required this.screenshotController,
    required this.userModel,
    required this.postModel,
    required this.isFullView,
  }) : super(key: key);

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
  bool isSharing = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.currentUser;
    final postID = widget.prayerRequest.postId;
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
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: AnimatedHeartButton(
                        isReacted: isReacted,
                        currentUser: currentUser,
                        userModel: widget.userModel,
                        postID: postID,
                        postModel: widget.postModel,
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
                widget.postModel,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.chat_bubble,
                  size: 20,
                  color: primaryColor,
                ),
                const SizedBox(width: 10),
                SmallText(text: 'Encourages', color: lighter),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            saveAndShare(
                widget.prayerRequest.postId!,
                widget.prayerRequest.userId!,
                "${widget.currentUser.displayName} shares ${widget.userModel.displayName!}'s prayer intention with you. ",
                widget.prayerRequest.text!);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: const Icon(
              Ionicons.share_social_outline,
              size: 20,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> addReact(String postID, UserModel currentUser) {
    return PrayerRequestRepository().addReaction(postID, currentUser.userId!,
        widget.userModel, currentUser, widget.postModel);
  }

  Future<bool> unreact(String postID, UserModel currentUser) {
    return PrayerRequestRepository().unReact(postID, currentUser.userId!);
  }

  Future saveAndShare(
      String postID, String postUser, String title, String description) async {
    context.loaderOverlay.show();
    MyDynamicLink()
        .generateDynamicLink(
            postID: postID,
            postUser: postUser,
            title: title,
            description: description)
        .then((value) async {
      await Share.share(value).then((value) => context.loaderOverlay.hide());
    });
  }

  void checkReaction(
    PrayerRequestPostModel prayerRequest,
    UserModel currentUser,
  ) async {
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
