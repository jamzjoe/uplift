import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/widgets/default_loading.dart';
import 'package:uplift/utils/widgets/friend_item.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

class FollowerPage extends StatefulWidget {
  const FollowerPage({
    super.key,
    required this.user,
    required this.currentUser,
  });

  final UserModel user;
  final UserModel currentUser;

  @override
  State<FollowerPage> createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeepAlivePage(
      child: FutureBuilder<List<UserFriendshipModel>>(
        future: FriendsRepository()
            .fetchApprovedFollowerFriendRequest(widget.user.userId!),
        builder: (context, result) {
          final data = result.data;
          if (result.connectionState == ConnectionState.waiting) {
            return const DefaultLoading();
          }
          if (!result.hasData || result.data!.isEmpty) {
            return const Center(
              child: NoDataMessage(text: 'No followers yet.'),
            );
          }
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            color: whiteColor,
            child: ListView(
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

  @override
  bool get wantKeepAlive => true;
}
