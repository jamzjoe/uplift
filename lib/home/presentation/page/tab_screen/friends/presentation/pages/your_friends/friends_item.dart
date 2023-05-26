import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendsItem extends StatelessWidget {
  const FriendsItem({
    super.key,
    required this.userFriendship,
    required this.currentUser,
  });
  final UserFriendshipModel userFriendship;
  final UserModel currentUser;

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
                          FutureBuilder<List<UserFriendshipModel>>(
                            future: FriendsRepository()
                                .fetchMutualFriendsWithFriend(
                              currentUser.userId!,
                              user.userId!,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final List<UserFriendshipModel> mutualFriends =
                                    snapshot.data!;
                                final int friendCount = mutualFriends.length;
                                if (friendCount == 0) {
                                  return const SmallText(
                                      text: 'No mutual friend',
                                      color: darkColor);
                                }
                                if (friendCount <= 2) {
                                  // Display photos of all mutual friends
                                  return Row(
                                    children: [
                                      ...mutualFriends.map(
                                        (friend) => ProfilePhoto(
                                          user: friend.userModel,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  // Display first two photos and remaining count as text
                                  final List<UserFriendshipModel>
                                      firstTwoFriends =
                                      mutualFriends.take(2).toList();
                                  final int remainingCount = friendCount - 2;
                                  final String friendsText = remainingCount == 1
                                      ? 'mutual friend'
                                      : 'mutual friends';

                                  return Row(
                                    children: [
                                      ...firstTwoFriends.map(
                                        (friend) => ProfilePhoto(
                                            user: friend.userModel,
                                            size: 15,
                                            radius: 60),
                                      ),
                                      SmallText(
                                          text:
                                              ' + $remainingCount $friendsText',
                                          color: darkColor)
                                    ],
                                  );
                                }
                              }

                              return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade100,
                                  highlightColor: whiteColor,
                                  child: const SizedBox());
                            },
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
