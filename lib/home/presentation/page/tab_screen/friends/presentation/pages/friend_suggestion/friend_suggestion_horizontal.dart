import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendSuggestionHorizontal extends StatelessWidget {
  const FriendSuggestionHorizontal({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsSuggestionsBlocBloc, FriendsSuggestionsBlocState>(
      builder: (context, state) {
        if (state is FriendsSuggestionLoadingSuccess) {
          final suggestions = state.users;
          if (suggestions.isEmpty) {
            return const SizedBox();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SmallText(
                  text: 'People with same interest like you:',
                  color: secondaryColor),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  itemCount: suggestions.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Stack(children: [
                          Positioned(
                              top: 0,
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Center(
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      primaryColor.withOpacity(0.5),
                                  child: const Icon(
                                    CupertinoIcons.add,
                                    size: 15,
                                    color: whiteColor,
                                  ),
                                ),
                              )),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () async {
                                  final FriendShipModel friendShipModel =
                                      FriendShipModel(
                                    sender: currentUser.userId,
                                    receiver: suggestions[index].userId,
                                    status: 'pending',
                                    timestamp: Timestamp.now(),
                                  );
                                  try {
                                    await FriendsRepository()
                                        .addFriendshipRequest(friendShipModel);
                                    await NotificationRepository.sendPushMessage(
                                        suggestions[index].deviceToken!,
                                        '${currentUser.displayName} sent you a friend a request.',
                                        "Uplift Notification",
                                        'add-friend');

                                    await NotificationRepository
                                        .addNotification(
                                      suggestions[index].userId!,
                                      'Friend request',
                                      'sent you a friend a request.',
                                    );
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                },
                                child: ProfilePhoto(
                                  user: suggestions[index],
                                  radius: 60,
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                              top: 0,
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.add,
                                  size: 15,
                                  color: whiteColor,
                                ),
                              )),
                        ]),
                        Flexible(
                            child: Text(suggestions[index].displayName ?? '',
                                style: const TextStyle(
                                    fontSize: 10,
                                    overflow: TextOverflow.ellipsis)))
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
