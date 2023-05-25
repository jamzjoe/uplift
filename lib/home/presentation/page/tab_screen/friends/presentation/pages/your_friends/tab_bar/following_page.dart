import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_item_shimmer.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/tab_bar/friends_tab_bar.dart';
import 'package:uplift/utils/widgets/friend_item.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({
    super.key,
    required this.user,
    required this.widget,
  });

  final UserModel user;
  final FriendsTabBarView widget;

  @override
  Widget build(BuildContext context) {
    return KeepAlivePage(
      child: FutureBuilder<List<UserFriendshipModel>>(
        future: FriendsRepository()
            .fetchApprovedFollowingRequest(user.userId!),
        builder: (context, result) {
          final data = result.data;
          if (result.connectionState ==
              ConnectionState.waiting) {
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
                  (e) => FriendItem(
                    userFriendship: e.userModel,
                    currentUser: widget.currentUser,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
