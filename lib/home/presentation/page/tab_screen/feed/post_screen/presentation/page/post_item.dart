import 'dart:developer';
import 'dart:typed_data';

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
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/full_post_view/full_post_view.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_actions.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_text.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/reactors_list.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/small_text.dart';
import '../../../../../../../../constant/constant.dart';
import 'post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'post_header.dart';

class PostItem extends StatefulWidget {
  const PostItem({
    Key? key,
    required this.postModel,
    required this.user,
    required this.allPost,
    this.fullView,
    this.isFriendsFeed,
  }) : super(key: key);

  final PostModel postModel;
  final List<PostModel> allPost;
  final UserModel user;
  final bool? fullView;
  final bool? isFriendsFeed;

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

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPostView(
              postModel: widget.postModel,
              currentUser: currentUser,
            ),
          ),
        );
        BlocProvider.of<EncourageBloc>(context)
            .add(FetchEncourageEvent(prayerRequest.postId!));
      },
      child: Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: widget.fullView! ? 0 : 2.5),
          child: Container(
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: lightColor.withOpacity(0.2),
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Profile, Name and Action Buttons
                  PostHeader(
                    isFriendsFeed: widget.isFriendsFeed,
                    user: user,
                    prayerRequest: prayerRequest,
                    currentUser: currentUser,
                    postModel: widget.allPost,
                  ),
                  PostText(prayerRequest: prayerRequest),
                  //Likes and Views Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<Map<String, dynamic>>(
                        stream: PrayerRequestRepository().getReactionInfo(
                          prayerRequest.postId!,
                          currentUser.userId!,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final bool isReacted = snapshot.data!['isReacted'];
                            final int reactionCount =
                                snapshot.data!['reactionCount'];
                            return Visibility(
                              visible: reactionCount != 0,
                              child: GestureDetector(
                                onTap: () {
                                  final array = snapshot.data!['users'];
                                  List<dynamic> userID = array
                                      .map((obj) => obj.keys.first)
                                      .toList()
                                      .cast<
                                          dynamic>(); // Add the cast method to explicitly convert to List<dynamic>

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReactorsList(
                                              userID: userID,
                                              currentUser: currentUser)));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Image(
                                      image: AssetImage('assets/prayed.png'),
                                      width: 20,
                                    ),
                                    SmallText(
                                      fontSize: 12,
                                      text: getReactionText(
                                        isReacted,
                                        reactionCount,
                                      ),
                                      color: lighter,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<EncourageBloc>(context).add(
                            FetchEncourageEvent(prayerRequest.postId!),
                          );
                          CustomDialog().showComment(
                            context,
                            currentUser,
                            user,
                            prayerRequest,
                            widget.postModel,
                          );
                        },
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('Comments')
                              .where('post_id', isEqualTo: prayerRequest.postId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.chat_bubble,
                                    color: lighter,
                                    size: 15,
                                  ),
                                  SmallText(
                                    fontSize: 12,
                                    text: snapshot.data!.size <= 1
                                        ? ' ${snapshot.data!.size} encourage'
                                        : ' ${snapshot.data!.size} encourages',
                                    color: lighter,
                                  ),
                                ],
                              );
                            }
                            return const SizedBox();
                          },
                        ),
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
      ),
    );
  }

  Future<String> saveImage() async {
    await [Permission.storage].request();
    try {
      final Uint8List? imageBytes =
          await screenshotController.capture(pixelRatio: 2.0);
      final result = await ImageGallerySaver.saveImage(
        imageBytes!,
        name: 'screenshot${DateTime.now()}.png',
      );
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
        await AuthServices.userID(),
      );

      isLiked = !isReacted;
    });
  }

  String getReactionText(bool isReacted, int reactionCount) {
    if (!isReacted && reactionCount == 1) {
      return 'You prayed this intention';
    } else if (!isReacted && reactionCount > 1) {
      if (reactionCount >= 1000) {
        // Convert count to "k" format
        final int countInK = (reactionCount / 1000).round();
        return 'You and $countInK k other prayed this intention';
      } else {
        final count = reactionCount - 1;
        return 'You and $count ${count == 1 ? 'other' : 'others'} prayed this intention';
      }
    } else {
      if (reactionCount >= 1000) {
        // Convert count to "k" format
        final int countInK = (reactionCount / 1000).round();
        return '$countInK k prayed this intention';
      } else {
        return '$reactionCount prayed this intention';
      }
    }
  }
}
