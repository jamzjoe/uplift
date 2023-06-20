import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_item.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

import '../../bloc/approved_friends_bloc/approved_friends_bloc.dart';

class FriendRequestItem extends StatelessWidget {
  const FriendRequestItem({
    super.key,
    required this.user,
    required this.currentUser,
    required this.mutualFriends,
  });
  final UserFriendshipModel user;
  final UserModel currentUser;
  final List<UserFriendshipModel> mutualFriends;

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = user.userModel;
    return GestureDetector(
      onTap: () => CustomDialog().showProfile(context, currentUser, userModel),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfilePhoto(user: userModel, radius: 15),
            const SizedBox(width: 15),
            Flexible(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: HeaderText(
                          text: userModel.displayName ?? 'User',
                          color: darkColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  MutualFriendWidget(mutualFriends: mutualFriends),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => FriendsRepository()
                              .ignore(user.friendshipID.friendshipId!),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: lightColor.withOpacity(0.2),
                            ),
                            child: Center(
                              child:
                                  DefaultText(text: 'Ignore', color: lighter),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await NotificationRepository.sendPushMessage(
                                userModel.deviceToken!,
                                '${currentUser.displayName} accepted your friend request.',
                                'Uplift Notification',
                                'friend-request');
                            await NotificationRepository.addNotification(
                                userModel.userId!,
                                'Uplift Notification',
                                ' accepted your friend request.',
                                type: 'accept');
                            if (context.mounted) {
                              BlocProvider.of<FriendRequestBloc>(context).add(
                                  FetchFriendRequestEvent(currentUser.userId!));
                              FriendsRepository()
                                  .acceptFriendshipRequest(
                                      userModel.userId!, currentUser.userId!)
                                  .then((value) {
                                BlocProvider.of<FriendsSuggestionsBlocBloc>(
                                        context)
                                    .add(FetchUsersEvent(currentUser.userId!));
                                BlocProvider.of<ApprovedFriendsBloc>(context)
                                    .add(FetchApprovedFriendRequest(
                                        currentUser.userId!));
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 15),
                            decoration: BoxDecoration(
                                color: linkColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                              child: DefaultText(
                                  text: 'Confirm', color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
