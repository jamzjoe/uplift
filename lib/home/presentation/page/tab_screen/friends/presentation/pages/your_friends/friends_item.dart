import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
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
  });
  final UserFriendshipModel userFriendship;
  final UserModel currentUser;
  final List<UserFriendshipModel> mutualFriends;

  @override
  Widget build(BuildContext context) {
    String friendShipID = userFriendship.friendshipID.friendshipId!;
    UserModel user = userFriendship.userModel;
    return GestureDetector(
      onTap: () {
        CustomDialog().showProfile(context, currentUser, user);
      },
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
                          Row(
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
                                  " + ${mutualFriends.length - 2} ${mutualFriends.length - 2 == 1 ? 'mutual friend' : 'mutual friends'}",
                                ),
                              if (mutualFriends.length <= 2)
                                Text(
                                  " ${mutualFriends.length} ${mutualFriends.length == 1 ? 'mutual friend' : 'mutual friends'}${mutualFriends.isEmpty ? '' : (mutualFriends.length == 1 ? '' : 's')}",
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      icon: Icon(CupertinoIcons.ellipsis,
                          color: secondaryColor.withOpacity(0.5)),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                              onTap: () =>
                                  BlocProvider.of<ApprovedFriendsBloc>(context)
                                      .add(UnfriendEvent(friendShipID)),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.remove_circle,
                                    color: secondaryColor,
                                  ),
                                  SizedBox(width: 5),
                                  DefaultText(
                                      text: 'Unfollow', color: secondaryColor),
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
    );
  }
}
