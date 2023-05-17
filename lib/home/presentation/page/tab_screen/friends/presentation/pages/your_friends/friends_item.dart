import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/safe_photo_viewer.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendsItem extends StatelessWidget {
  const FriendsItem({
    super.key,
    required this.userFriendship,
  });
  final UserFriendshipModel userFriendship;

  @override
  Widget build(BuildContext context) {
    String friendShipID = userFriendship.friendshipID.friendshipId!;
    UserModel user = userFriendship.userModel;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          user.photoUrl == null
              ? const CircleAvatar(
                  backgroundImage: AssetImage('assets/default.png'),
                )
              : SafePhotoViewer(user: user),
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
                            color: secondaryColor,
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
