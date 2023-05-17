import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/just_now.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/report_dialog.dart';
import 'package:uplift/utils/widgets/small_text.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          user.photoUrl == null || prayerRequest.name == 'Uplift User'
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
                  onTap: () async {
                    context.pushNamed('friend-screen');
                  },
                  text: prayerRequest.name!.isEmpty
                      ? user.displayName!
                      : prayerRequest.name!,
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
                        leading: Icon(
                            CupertinoIcons.exclamationmark_bubble_fill,
                            color: Colors.red[300]),
                        title: const DefaultText(
                            text: 'Report Post', color: secondaryColor),
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
                      child: ListTile(
                        dense: true,
                        leading: Icon(CupertinoIcons.delete_left_fill,
                            color: Colors.red[300]),
                        title: const DefaultText(
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

  Widget _buildReportChoice(String choice) {
    return ListTile(
      leading: Checkbox(value: true, onChanged: (value) {}),
      title: Text(choice),
      onTap: () {},
    );
  }
}
