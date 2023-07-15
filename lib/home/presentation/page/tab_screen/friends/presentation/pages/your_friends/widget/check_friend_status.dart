import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friendship_functions.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../../../../../../../authentication/data/model/user_model.dart';
import '../../../../data/model/new_friendship_model.dart';
import '../../../../domain/repository/friends_repository.dart';

class CheckFriendsStatusWidget extends StatefulWidget {
  const CheckFriendsStatusWidget({
    Key? key,
    required this.user,
    required this.currentUser,
  }) : super(key: key);

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
      child: FutureBuilder<Status?>(
        future: FriendshipRequest().checkStatus(widget.user.userId!),
        builder: (BuildContext context, AsyncSnapshot<Status?> snapshot) {
          log(snapshot.data.toString());
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
                  color: whiteColor,
                ),
                color: Colors.red,
              ),
            );
          } else if (snapshot.hasError) {
            // Show an error message if an error occurred
            return SizedBox(
              width: 140,
              child: Center(child: Text(snapshot.error.toString())),
            );
          } else if (snapshot.hasData) {
            final friendshipStatus = snapshot.data;

            if (friendshipStatus != null) {
              // User is a friend
              if (friendshipStatus.status == 'pending') {
                return CustomContainer(
                  borderColor: Colors.red,
                  width: 140,
                  borderWidth: .5,
                  onTap: () {
                    log(friendshipStatus.friendshipID!);
                    FriendsRepository()
                        .unfriend(friendshipStatus.friendshipID!);
                    refreshScreen();
                  },
                  widget: const SmallText(
                    textAlign: TextAlign.center,
                    text: 'Cancel request',
                    color: Colors.red,
                  ),
                  color: whiteColor,
                );
              } else if (friendshipStatus.status == 'rejected') {
                return CustomContainer(
                  onTap: () {
                    FriendsRepository().reAdd(friendshipStatus.friendshipID!);
                    refreshScreen();
                  },
                  borderColor: linkColor,
                  width: 140,
                  widget: const SmallText(
                    text: 'Follow',
                    color: whiteColor,
                    textAlign: TextAlign.center,
                  ),
                  color: linkColor,
                );
              } else {
                return CustomContainer(
                  onTap: () {
                    log(friendshipStatus.friendshipID!);
                    FriendsRepository()
                        .unfriend(friendshipStatus.friendshipID!);
                    refreshScreen();
                  },
                  borderWidth: .5,
                  width: 140,
                  borderColor: linkColor,
                  widget: const SmallText(
                    text: 'Unfollow',
                    color: linkColor,
                    textAlign: TextAlign.center,
                  ),
                  color: whiteColor,
                );
              }
            } else {
              // User is not a friend
              return CustomContainer(
                onTap: () {
                  FriendsRepository().addFriend(
                    widget.currentUser.userId!,
                    widget.user.userId,
                    widget.user.deviceToken!,
                    widget.currentUser.displayName!,
                  );
                  refreshScreen();
                },
                borderColor: linkColor,
                width: 140,
                widget: const SmallText(
                  text: 'Follow',
                  color: whiteColor,
                  textAlign: TextAlign.center,
                ),
                color: linkColor,
              );
            }
          } else {
            return CustomContainer(
              onTap: () {
                FriendsRepository().addFriend(
                  widget.currentUser.userId!,
                  widget.user.userId,
                  widget.user.deviceToken!,
                  widget.currentUser.displayName!,
                );
                refreshScreen();
              },
              borderColor: linkColor,
              width: 140,
              widget: const SmallText(
                text: 'Follow',
                color: whiteColor,
                textAlign: TextAlign.center,
              ),
              color: linkColor,
            );
          }
        },
      ),
    );
  }
}
