import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendRequestItem extends StatelessWidget {
  const FriendRequestItem({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          user.photoUrl == null
              ? const CircleAvatar(
                  backgroundImage: AssetImage('assets/default.png'),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl!),
                ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderText(
                      text: user.displayName ?? 'User',
                      color: secondaryColor,
                      size: 18,
                    ),
                    const SmallText(text: '1w ', color: lightColor)
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await NotificationRepository.sendPushMessage(
                              user.displayName ?? 'Anonymous User',
                              '${user.displayName ?? 'Anonymous User'} accepted your friend request.',
                              'Confirmation');
                          await NotificationRepository.addNotification(
                            await AuthServices.userID(),
                            'Confirmation',
                            '${user.displayName ?? 'Anonymous User'} accepted your friend request.',
                          );
                          if (context.mounted) {
                            BlocProvider.of<FriendRequestBloc>(context).add(
                                FetchFriendRequestEvent(
                                    await AuthServices.userID()));
                          }
                          FriendsRepository().acceptFriendshipRequest(
                              user.userId!, await AuthServices.userID());
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
                              text: 'Delete', color: secondaryColor),
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
