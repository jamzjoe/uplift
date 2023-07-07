import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../friends/presentation/pages/your_friends/widget/check_friend_status.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key, required this.user, required this.currentUser});
  final UserModel user;
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProfilePhoto(
          radius: 25,
          user: user,
          size: 80,
        ),
        defaultSpace,
        HeaderText(text: user.displayName ?? 'Name', color: darkColor),
        defaultSpace,
        SmallText(text: user.emailAddress ?? 'Email address', color: lighter),
        SmallText(text: user.phoneNumber ?? 'Phone number', color: lighter),
        SmallText(text: user.bio ?? '', color: secondaryColor),
        defaultSpace,
        GestureDetector(
          onTap: () async {
            final currentUserID = await AuthServices.userID();

            if (currentUserID == user.userId) {
              if (context.mounted) {
                context.pop();
                CustomDialog.showErrorDialog(
                    context,
                    'Cannot send friend request to yourself.',
                    'Sent failed',
                    'Confirm');
              }
            } else {
              final addFriend = await FriendsRepository()
                  .addFriend(currentUserID, user.userId);
              if (addFriend) {
                if (context.mounted) {
                  // FriendsRepository().addFriendshipRequest(user);
                  context.pop();
                  CustomDialog.showSuccessDialog(
                      context,
                      'Friend request is successfully sent.',
                      'Request Sent',
                      'Confirm');
                }
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: whiteColor,
            ),
            child:
                CheckFriendsStatusWidget(user: user, currentUser: currentUser),
          ),
        )
      ],
    );
  }
}
