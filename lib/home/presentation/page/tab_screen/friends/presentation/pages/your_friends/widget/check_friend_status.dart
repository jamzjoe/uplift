import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/constant/constant.dart';
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
              baseColor: secondaryColor.withOpacity(0.2),
              highlightColor: Colors.grey.shade100.withOpacity(0.5),
              child: TextButton.icon(
                label: const SmallText(
                  text: 'Processing',
                  color: primaryColor,
                ),
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.add_circled_solid,
                  color: primaryColor,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // Show an error message if an error occurred
            return Text('Error: ${snapshot.error}');
          } else {
            final friendshipStatus = snapshot.data;

            if (friendshipStatus != null) {
              // User is a friend
              if (friendshipStatus.status.status == 'pending') {
                return TextButton.icon(
                    onPressed: () {
                      FriendsRepository().unfriend(
                          friendshipStatus.friendshipID.friendshipId!);
                      refreshScreen();
                    },
                    icon: const Icon(CupertinoIcons.clear_circled_solid,
                        color: Colors.red),
                    label: const SmallText(
                        text: 'Cancel request', color: Colors.red));
              }
              return TextButton.icon(
                label: const SmallText(
                  text: 'Unfollow',
                  color: primaryColor,
                ),
                onPressed: () {
                  FriendsRepository()
                      .unfriend(friendshipStatus.friendshipID.friendshipId!);
                  refreshScreen();
                },
                icon: const Icon(
                  CupertinoIcons.add_circled_solid,
                  color: primaryColor,
                ),
              );
            } else {
              // User is not a friend
              return TextButton.icon(
                label: const SmallText(
                  text: 'Follow',
                  color: darkColor,
                ),
                onPressed: () {
                  FriendsRepository().addFriend(
                      widget.currentUser.userId!, widget.user.userId);
                  refreshScreen();
                },
                icon: const Icon(
                  CupertinoIcons.add_circled_solid,
                  color: primaryColor,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
