import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/header_text.dart';
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
        SmallText(
            textAlign: TextAlign.center,
            text: user.bio ?? '',
            color: secondaryColor),
        defaultSpace,
        Visibility(
          visible: user.userId != currentUser.userId,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: whiteColor,
            ),
            child:
                CheckFriendsStatusWidget(user: user, currentUser: currentUser),
          ),
        ),
        TextButton.icon(
            onPressed: () {
              context.pushNamed('friends-list', extra: currentUser);
            },
            icon: const Icon(CupertinoIcons.person_2_fill, color: primaryColor),
            label: const SmallText(
                text: 'View all of your friends', color: darkColor))
      ],
    );
  }
}
