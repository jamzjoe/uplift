import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/new_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

import '../../../../../../../../utils/widgets/small_text.dart';

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
    return GestureDetector(
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

                            // FutureBuilder<List<UserFriendshipModel>>(
                            //   future: FriendsRepository()
                            //       .fetchMutualFriendsWithFriend(
                            //     currentUser.userId!,
                            //     user.userId!,
                            //   ),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.hasData) {
                            //       screenContext.loaderOverlay.hide();
                            //       final List<UserFriendshipModel>
                            //           mutualFriends = snapshot.data!;
                            //       final int friendCount = mutualFriends.length;
                            //       if (friendCount == 0) {
                            //         return const SmallText(
                            //             text: 'No mutual friend',
                            //             color: darkColor);
                            //       }
                            //       if (friendCount <= 2) {
                            //         // Display photos of all mutual friends
                            //         return Row(
                            //           children: [
                            //             ...mutualFriends.map(
                            //               (friend) => ProfilePhoto(
                            //                 user: friend.userModel,
                            //                 size: 15,
                            //               ),
                            //             ),
                            //           ],
                            //         );
                            //       } else {
                            //         // Display first two photos and remaining count as text
                            //         final List<UserFriendshipModel>
                            //             firstTwoFriends =
                            //             mutualFriends.take(2).toList();
                            //         final int remainingCount = friendCount - 2;
                            //         final String friendsText =
                            //             remainingCount == 1
                            //                 ? 'mutual friend'
                            //                 : 'mutual friends';

                            //         return Row(
                            //           children: [
                            //             ...firstTwoFriends.map(
                            //               (friend) => ProfilePhoto(
                            //                   user: friend.userModel,
                            //                   size: 15,
                            //                   radius: 60),
                            //             ),
                            //             SmallText(
                            //                 text:
                            //                     ' + $remainingCount $friendsText',
                            //                 color: darkColor)
                            //           ],
                            //         );
                            //       }
                            //     }

                            //     return Shimmer.fromColors(
                            //         baseColor: Colors.grey.shade100,
                            //         highlightColor: primaryColor,
                            //         child: const SizedBox());
                            //   },
                            // )
                          ],
                        ),
                      ),
                      FutureBuilder<NewUserFriendshipModel?>(
                        future: FriendsRepository()
                            .checkFriendsStatus(widget.user.userId!),
                        builder: (BuildContext context,
                            AsyncSnapshot<NewUserFriendshipModel?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Show a loading indicator while fetching the data
                            return Shimmer.fromColors(
                              baseColor: secondaryColor.withOpacity(0.2),
                              highlightColor:
                                  Colors.grey.shade100.withOpacity(0.5),
                              child: TextButton.icon(
                                label: const SmallText(
                                  text: 'Processing',
                                  color: primaryColor,
                                ),
                                onPressed: () {},
                                icon: const Icon(
                                  CupertinoIcons.add_circled_solid,
                                  color: primaryColor,
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            // Show an error message if an error occurred
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final friendshipStatus = snapshot.data;

                            if (friendshipStatus != null) {
                              // User is a friend
                              if (friendshipStatus.status.status == 'pending') {
                                return TextButton.icon(
                                  icon: const Icon(
                                    CupertinoIcons.clock_solid,
                                    color: primaryColor,
                                  ),
                                  label: const SmallText(
                                    text: 'Request Pending',
                                    color: primaryColor,
                                  ),
                                  onPressed: () {
                                    FriendsRepository().unfriend(
                                        friendshipStatus
                                            .friendshipID.friendshipId!);
                                    refreshScreen();
                                  },
                                );
                              }
                              return TextButton.icon(
                                label: const SmallText(
                                  text: 'Unfollow',
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  FriendsRepository().unfriend(friendshipStatus
                                      .friendshipID.friendshipId!);
                                  refreshScreen();
                                },
                                icon: const Icon(
                                  CupertinoIcons.add_circled_solid,
                                  color: primaryColor,
                                ),
                              );
                            } else {
                              // User is not a friend
                              return TextButton.icon(
                                label: const SmallText(
                                  text: 'Follow',
                                  color: darkColor,
                                ),
                                onPressed: () {
                                  FriendsRepository().addFriend(
                                      widget.currentUser.userId!,
                                      widget.user.userId);
                                  refreshScreen();
                                },
                                icon: const Icon(
                                  CupertinoIcons.add_circled_solid,
                                  color: primaryColor,
                                ),
                              );
                            }
                          }
                        },
                      ),

                      // GestureDetector(
                      //   onTap: () async {
                      //     final FriendShipModel friendShipModel =
                      //         FriendShipModel(
                      //       sender: currentUser.userId,
                      //       receiver: user.userId,
                      //       status: 'pending',
                      //       timestamp: Timestamp.now(),
                      //     );
                      //     try {
                      //       await FriendsRepository()
                      //           .addFriendshipRequest(friendShipModel);
                      //       await NotificationRepository.sendPushMessage(
                      //           user.deviceToken!,
                      //           '${currentUser.displayName} sent you a friend a request.',
                      //           "Uplift Notification",
                      //           'add-friend');

                      //       await NotificationRepository.addNotification(
                      //         user.userId!,
                      //         'Friend request',
                      //         'sent you a friend a request.',
                      //       );
                      //     } catch (e) {
                      //       log(e.toString());
                      //     } finally {}
                      //   },
                      //   child: Icon(CupertinoIcons.add_circled_solid,
                      //       color: secondaryColor.withOpacity(0.4), size: 30),
                      // )
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
