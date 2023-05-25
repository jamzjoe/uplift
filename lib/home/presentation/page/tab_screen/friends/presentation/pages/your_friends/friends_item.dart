import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_feed.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
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
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return FriendsFeed(
                  userModel: userFriendship.userModel,
                  currentUser: currentUser);
            });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
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
                            SmallText(
                                text:
                                    'Friends since ${user.createdAt!.toDate().year}',
                                color: lightColor),
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
                                    BlocProvider.of<ApprovedFriendsBloc>(
                                            context)
                                        .add(UnfriendEvent(friendShipID)),
                                child: Row(
                                  children: const [
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
