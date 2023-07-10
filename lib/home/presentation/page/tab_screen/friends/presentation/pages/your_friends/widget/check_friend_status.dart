import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../../../../../../../authentication/data/model/user_model.dart';
import '../../../../data/model/new_friendship_model.dart';
import '../../../../domain/repository/friends_repository.dart';

class CheckFriendsStatusWidget extends StatefulWidget {
  const CheckFriendsStatusWidget({
    super.key,
    required this.user,
    required this.currentUser,
  });

  final UserModel user;
  final UserModel currentUser;

  @override
  State<CheckFriendsStatusWidget> createState() =>
      _CheckFriendsStatusWidgetState();
}

class _CheckFriendsStatusWidgetState extends State<CheckFriendsStatusWidget> {
  bool refreshFlag = false;

  void refreshScreen() {
    setState(() {
      refreshFlag = !refreshFlag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: FutureBuilder<NewUserFriendshipModel?>(
        future: FriendsRepository().checkFriendsStatus(widget.user.userId!),
        builder: (BuildContext context,
            AsyncSnapshot<NewUserFriendshipModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while fetching the data
            return Shimmer.fromColors(
                baseColor: primaryColor.withOpacity(0.1),
                highlightColor: Colors.grey.shade100.withOpacity(0.2),
                child: CustomContainer(
                    width: 130,
                    onTap: () {},
                    widget: const SmallText(
                        textAlign: TextAlign.center,
                        text: 'Processing',
                        color: whiteColor),
                    color: Colors.red));
          } else if (snapshot.hasError) {
            // Show an error message if an error occurred
            return Text('Error: ${snapshot.error}');
          } else {
            final friendshipStatus = snapshot.data;

            if (friendshipStatus != null) {
              // User is a friend
              if (friendshipStatus.status.status == 'pending') {
                return CustomContainer(
                    borderColor: Colors.red,
                    width: 130,
                    borderWidth: .5,
                    onTap: () {
                      FriendsRepository().unfriend(
                          friendshipStatus.friendshipID.friendshipId!);
                      refreshScreen();
                    },
                    widget: const SmallText(
                        textAlign: TextAlign.center,
                        text: 'Cancel request',
                        color: Colors.red),
                    color: whiteColor);
              }
              return CustomContainer(
                  onTap: () {
                    FriendsRepository()
                        .unfriend(friendshipStatus.friendshipID.friendshipId!);
                    refreshScreen();
                  },
                  borderWidth: .5,
                  width: 130,
                  borderColor: linkColor,
                  widget: const SmallText(
                    text: 'Unfollow',
                    color: linkColor,
                    textAlign: TextAlign.center,
                  ),
                  color: whiteColor);
            } else {
              // User is not a friend
              return CustomContainer(
                  onTap: () {
                    FriendsRepository().addFriend(
                        widget.currentUser.userId!,
                        widget.user.userId,
                        widget.user.deviceToken!,
                        widget.user.displayName!);
                    refreshScreen();
                  },
                  borderColor: linkColor,
                  width: 130,
                  widget: const SmallText(
                    text: 'Follow',
                    color: whiteColor,
                    textAlign: TextAlign.center,
                  ),
                  color: linkColor);
            }
          }
        },
      ),
    );
  }
}
