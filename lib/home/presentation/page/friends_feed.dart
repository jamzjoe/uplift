import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_status.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_item_shimmer.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/friend_item.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';
import 'package:uplift/utils/widgets/post_item_shimmer.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import 'tab_screen/feed/post_screen/data/model/post_model.dart';

class FriendsFeed extends StatefulWidget {
  const FriendsFeed(
      {Key? key,
      required this.userModel,
      this.isSelf,
      this.friendshipID,
      required this.currentUser})
      : super(key: key);
  final UserModel userModel;
  final UserModel currentUser;
  final bool? isSelf;
  final String? friendshipID;

  @override
  State<FriendsFeed> createState() => _FriendsFeedState();
}

class _FriendsFeedState extends State<FriendsFeed> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final UserModel user = widget.userModel;
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const SizedBox(height: 60),
            GestureDetector(
              onTap: () =>
                  context.pushNamed('photo_view', extra: user.photoUrl),
              child: ProfilePhoto(
                user: user,
                radius: 60,
                size: 90,
              ),
            ),
            const SizedBox(height: 10),
            HeaderText(text: user.displayName ?? '', color: darkColor),
            SmallText(text: user.emailAddress ?? '', color: lightColor),
            defaultSpace,
            SmallText(
                text: user.bio?.isEmpty ?? true ? 'User Bio' : user.bio ?? '',
                color: darkColor),
            defaultSpace,
            StreamBuilder<FriendshipStatus?>(
              stream: FriendsRepository().checkFriendsStatus(user.userId!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  FriendshipStatus? data = snapshot.data;
                  bool isFriend = data!.isFriend;
                  String friendshipID = data.friendshipID;
                  if (isFriend) {
                    return CustomContainer(
                      onTap: () {
                        FriendsRepository().unfriend(friendshipID);
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                      widget:
                          const SmallText(text: 'UNFOLLOW', color: whiteColor),
                      color: secondaryColor,
                    );
                  } else {
                    return CustomContainer(
                      onTap: () {
                        FriendsRepository().addFriend(
                          widget.currentUser.userId ?? '',
                          user.userId,
                        );
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                      widget:
                          const SmallText(text: 'FOLLOW', color: whiteColor),
                      color: secondaryColor,
                    );
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade100,
                    highlightColor: whiteColor,
                    child: const CustomContainer(
                      widget: SmallText(text: 'FOLLOW', color: whiteColor),
                      color: secondaryColor,
                    ),
                  );
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade100,
                    highlightColor: whiteColor,
                    child: const CustomContainer(
                      widget: SmallText(text: 'FOLLOW', color: whiteColor),
                      color: secondaryColor,
                    ),
                  );
                }
              },
            ),
            defaultSpace,
            TabBar(
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                tabs: const [
                  Tab(
                    text: 'Prayer Intentions',
                  ),
                  Tab(
                    text: 'Followers',
                  ),
                  Tab(
                    text: 'Following',
                  )
                ]),
            Expanded(
              child: TabBarView(children: [
                FutureBuilder<List<PostModel>>(
                    future: PrayerRequestRepository().getPrayerIntentions(
                        user.userId!, widget.isSelf ?? false),
                    builder: (context, result) {
                      final data = result.data;
                      if (result.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const PostItemShimmerLoading();
                            });
                      }
                      if (!result.hasData || result.data!.isEmpty) {
                        return const Center(
                          child:
                              NoDataMessage(text: 'No prayer intention found.'),
                        );
                      }
                      return Container(
                        color: Colors.grey.shade100,
                        child: ListView(
                          children: [
                            ...data!.map((e) => PostItem(
                                postModel: e,
                                user: e.userModel,
                                fullView: false))
                          ],
                        ),
                      );
                    }),
                FutureBuilder<List<UserFriendshipModel>>(
                    future: FriendsRepository()
                        .fetchApprovedFollowerFriendRequest(user.userId!),
                    builder: (context, result) {
                      final data = result.data;
                      if (result.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                            padding: const EdgeInsets.all(15),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const FriendsShimmerItem();
                            });
                      }
                      if (!result.hasData || result.data!.isEmpty) {
                        return const Center(
                          child: NoDataMessage(text: 'No followers yet.'),
                        );
                      }
                      return Container(
                        color: whiteColor,
                        child: ListView(
                          padding: const EdgeInsets.all(15),
                          children: [
                            ...data!.map(
                                (e) => FriendItem(userFriendship: e.userModel))
                          ],
                        ),
                      );
                    }),
                FutureBuilder<List<UserFriendshipModel>>(
                    future: FriendsRepository()
                        .fetchApprovedFollowingRequest(user.userId!),
                    builder: (context, result) {
                      final data = result.data;
                      if (result.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                            padding: const EdgeInsets.all(15),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const FriendsShimmerItem();
                            });
                      }
                      if (!result.hasData || result.data!.isEmpty) {
                        return const Center(
                          child: NoDataMessage(text: 'No following yet.'),
                        );
                      }
                      return Container(
                        color: whiteColor,
                        child: ListView(
                          padding: const EdgeInsets.all(15),
                          children: [
                            ...data!.map(
                                (e) => FriendItem(userFriendship: e.userModel))
                          ],
                        ),
                      );
                    }),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
