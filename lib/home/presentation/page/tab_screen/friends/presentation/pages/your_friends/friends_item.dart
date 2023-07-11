import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_approved_mutual.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

class FriendsItem extends StatelessWidget {
  const FriendsItem({
    super.key,
    required this.userFriendship,
    required this.currentUser,
    required this.mutualFriends,
    required this.users,
  });
  final UserFriendshipModel userFriendship;
  final UserModel currentUser;
  final List<UserFriendshipModel> mutualFriends;
  final List<UserApprovedMutualFriends> users;
  @override
  Widget build(BuildContext context) {
    String friendShipID = userFriendship.friendshipID.friendshipId!;
    UserModel user = userFriendship.userModel;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        CustomDialog().showProfile(context, currentUser, user);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            ProfilePhoto(user: user, radius: 15),
            const SizedBox(width: 15),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderText(
                              text: user.displayName ?? 'User',
                              color: darkColor,
                              size: 18,
                            ),
                            const SizedBox(height: 5),
                            MutualFriendWidget(mutualFriends: mutualFriends)
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        icon: Icon(CupertinoIcons.ellipsis,
                            color: secondaryColor.withOpacity(0.5)),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                                onTap: () => BlocProvider.of<
                                        ApprovedFriendsBloc>(context)
                                    .add(UnfriendEvent(friendShipID, users)),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.remove_circle,
                                      color: secondaryColor,
                                    ),
                                    SizedBox(width: 5),
                                    DefaultText(
                                        text: 'Unfollow',
                                        color: secondaryColor),
                                  ],
                                ))
                          ];
                        },
                      )
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

class MutualFriendWidget extends StatelessWidget {
  const MutualFriendWidget({
    Key? key,
    required this.mutualFriends,
  }) : super(key: key);

  final List<UserFriendshipModel> mutualFriends;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...mutualFriends
            .take(2)
            .map((e) => ProfilePhoto(
                  user: e.userModel,
                  radius: 60,
                  size: 15,
                ))
            .toList(),
        if (mutualFriends.length > 2)
          Text(
            " + ${mutualFriends.length - 2} ${mutualFriends.length - 2 == 1 ? 'mutual friend' : 'mutual friend'}",
          ),
        if (mutualFriends.length <= 2)
          Text(
            " ${mutualFriends.length} ${mutualFriends.length == 1 ? 'mutual friend' : 'mutual friend'}${mutualFriends.isEmpty ? '' : 's'}",
          ),
      ],
    );
  }
}
