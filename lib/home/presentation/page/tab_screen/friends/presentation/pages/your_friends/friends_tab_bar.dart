import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_item_shimmer.dart';
import 'package:uplift/utils/widgets/friend_item.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';
import 'package:uplift/utils/widgets/post_item_shimmer.dart';

class FriendsTabBarView extends StatefulWidget {
  const FriendsTabBarView({super.key, required this.user, this.isSelf});
  final UserModel user;
  final bool? isSelf;

  @override
  State<FriendsTabBarView> createState() => _FriendsTabBarViewState();
}

class _FriendsTabBarViewState extends State<FriendsTabBarView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Builder(builder: (context) {
      return Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
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
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents scrolling between tabs
                  children: [
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
                            },
                          );
                        }
                        if (!result.hasData || result.data!.isEmpty) {
                          return const Center(
                            child: NoDataMessage(
                                text: 'No prayer intention found.'),
                          );
                        }
                        return Container(
                          color: Colors.grey.shade100,
                          child: ListView(
                            children: [
                              ...data!.map(
                                (e) => PostItem(
                                  postModel: e,
                                  user: e.userModel,
                                  fullView: false,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
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
                            },
                          );
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
                                (e) => FriendItem(userFriendship: e.userModel),
                              )
                            ],
                          ),
                        );
                      },
                    ),
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
                            },
                          );
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
                                (e) => FriendItem(userFriendship: e.userModel),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
