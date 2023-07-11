import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/widget/check_friend_status.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

class AddFriendItem extends StatefulWidget {
  const AddFriendItem({
    super.key,
    required this.user,
    required this.currentUser,
    this.controller,
    required this.screenContext,
    required this.mutualFriends,
  });
  final List<UserFriendshipModel> mutualFriends;
  final UserModel user;
  final UserModel currentUser;
  final TextEditingController? controller;
  final BuildContext screenContext;

  @override
  State<AddFriendItem> createState() => _AddFriendItemState();
}

class _AddFriendItemState extends State<AddFriendItem> {
  bool _refreshFlag = false;

  void refreshScreen() {
    setState(() {
      _refreshFlag = !_refreshFlag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          CustomDialog().showProfile(context, widget.currentUser, widget.user),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfilePhoto(
              user: widget.user,
              radius: 15,
            ),
            const SizedBox(width: 15),
            Flexible(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderText(
                                text:
                                    widget.user.displayName ?? 'Anonymous User',
                                color: darkColor,
                                size: 16),
                            Row(
                              children: [
                                ...widget.mutualFriends
                                    .take(2)
                                    .map((e) => ProfilePhoto(
                                          user: e.userModel,
                                          radius: 60,
                                          size: 15,
                                        ))
                                    .toList(),
                                if (widget.mutualFriends.length > 2)
                                  Text(
                                    " + ${widget.mutualFriends.length - 2} ${widget.mutualFriends.length - 2 == 1 ? 'mutual friend' : 'mutual friends'}",
                                  ),
                                if (widget.mutualFriends.length <= 2)
                                  Text(
                                    " ${widget.mutualFriends.length} ${widget.mutualFriends.length == 1 ? 'mutual friend' : 'mutual friends'}",
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CheckFriendsStatusWidget(
                          user: widget.user, currentUser: widget.currentUser)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
