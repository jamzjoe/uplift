import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_feed.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/just_now.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/report_dialog.dart';
import 'package:uplift/utils/widgets/set_reminders_dialog.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.user,
    required this.prayerRequest,
    required this.currentUser,
    required this.postModel,
  });

  final UserModel user;
  final UserModel currentUser;
  final PrayerRequestPostModel prayerRequest;
  final List<PostModel> postModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        user.photoUrl == null || prayerRequest.name == 'Uplift User'
            ? const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/default.png'),
              )
            : GestureDetector(
                onTap: () =>
                    context.pushNamed('photo_view', extra: user.photoUrl ?? ''),
                child: ProfilePhoto(
                  user: user,
                  radius: 10,
                ),
              ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(
                onTap: () async {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                  if (prayerRequest.name!.isNotEmpty) {
                    CustomDialog.showErrorDialog(
                        context,
                        "This user set his/her post into private.",
                        'Request Denied',
                        'Confirm');
                    return;
                  }
                  showFlexibleBottomSheet(
                    minHeight: 0,
                    initHeight: 0.92,
                    maxHeight: 1,
                    isSafeArea: true,
                    context: context,
                    builder: (context, scrollController, bottomSheetOffset) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [], // Remove the shadow by using an empty list of BoxShadow
                        ),
                        child: FriendsFeed(
                          userModel: user,
                          isSelf: prayerRequest.userId == userID,
                          currentUser: currentUser,
                          scrollController: scrollController,
                        ),
                      );
                    },
                    anchors: [0, 0.5, 1],
                  );
                },
                text: prayerRequest.name!.isEmpty
                    ? user.displayName!
                    : prayerRequest.name!,
                color: darkColor,
                size: 18,
              ),
              SmallText(
                  text: DateFeature()
                      .formatDateTime(prayerRequest.date!.toDate()),
                  color: lighter)
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopupMenuButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                CupertinoIcons.ellipsis,
                size: 15,
                color: darkColor,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                    onTap: () async {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                const ReportPrayerRequestDialog());
                      });
                    },
                    child: ListTile(
                      dense: true,
                      leading: Icon(CupertinoIcons.exclamationmark_bubble_fill,
                          color: Colors.red[300]),
                      title: const DefaultText(
                          text: 'Report Post', color: darkColor),
                    )),
                PopupMenuItem(
                    onTap: () async {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        showDialog(
                            context: context,
                            builder: (context) => SetReminderDialog());
                      });
                    },
                    child: ListTile(
                      dense: true,
                      leading: Icon(CupertinoIcons.bell_circle_fill,
                          color: Colors.red[300]),
                      title: const DefaultText(
                          text: 'Set reminder for this post', color: darkColor),
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
                                if (prayerRequest.userId ==
                                    currentUser.userId) {
                                  BlocProvider.of<GetPrayerRequestBloc>(context)
                                      .add(DeletePost(
                                          userID,
                                          prayerRequest.postId!,
                                          postModel,
                                          context));
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
                    child: ListTile(
                      dense: true,
                      leading: Icon(CupertinoIcons.delete_left_fill,
                          color: Colors.red[300]),
                      title: const DefaultText(
                          text: 'Delete Post', color: darkColor),
                    ))
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildReportChoice(String choice) {
    return ListTile(
      leading: Checkbox(value: true, onChanged: (value) {}),
      title: Text(choice),
      onTap: () {},
    );
  }
}
