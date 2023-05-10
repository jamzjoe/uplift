import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/safe_photo_viewer.dart';

class FriendRequestItem extends StatelessWidget {
  const FriendRequestItem({
    super.key,
    required this.user,
  });
  final UserFriendshipModel user;

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = user.userModel;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          userModel.photoUrl == null
              ? const CircleAvatar(
                  backgroundImage: AssetImage('assets/default.png'),
                )
              : SafePhotoViewer(user: userModel),
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
                        color: secondaryColor,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await NotificationRepository.sendPushMessage(
                              userModel.displayName ?? 'Anonymous User',
                              '${userModel.displayName} accepted your friend request.',
                              'Accepted request');
                          await NotificationRepository.addNotification(
                            userModel.userId!,
                            'Accepted request',
                            ' accepted your friend request.',
                          );
                          if (context.mounted) {
                            BlocProvider.of<FriendRequestBloc>(context).add(
                                FetchFriendRequestEvent(
                                    await AuthServices.userID()));
                          }
                          FriendsRepository().acceptFriendshipRequest(
                              userModel.userId!, await AuthServices.userID());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 15),
                          decoration: BoxDecoration(
                              color: linkColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Center(
                            child:
                                DefaultText(text: 'Confirm', color: whiteColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: lightColor.withOpacity(0.2),
                        ),
                        child: const Center(
                          child: DefaultText(
                              text: 'Ignore', color: secondaryColor),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
