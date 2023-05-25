import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';
import 'friends_item.dart';

class FollowingListScreen extends StatefulWidget {
  const FollowingListScreen({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  State<FollowingListScreen> createState() => _FollowingListScreenState();
}

class _FollowingListScreenState extends State<FollowingListScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApprovedFriendsBloc, ApprovedFriendsState>(
      builder: (context, state) {
        if (state is ApprovedFriendsSuccess2) {
          if (state.approvedFriendList.isEmpty) {
            return const Padding(
                padding: EdgeInsets.only(top: 100),
                child: NoDataMessage(text: 'No users found...'));
          }
          return ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              ...state.approvedFriendList
                  .map((e) => FriendsItem(userFriendship: e, currentUser: widget.currentUser,))
            ],
          );
        } else if (state is EmptySearchResult) {
          return const Center(
            child: NoDataMessage(text: 'No users found'),
          );
        }
        return const SizedBox();
      },
    );
  }

  void searchFriend(String value) {}
}
