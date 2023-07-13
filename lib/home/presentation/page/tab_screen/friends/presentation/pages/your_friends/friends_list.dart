import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestion_list.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friend_list_view.dart';
import 'package:uplift/utils/widgets/default_loading.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApprovedFriendsBloc, ApprovedFriendsState>(
      builder: (context, state) {
        if (state is ApprovedFriendsSuccess2) {
          return FriendListView(
              approvedFriendList: state.approvedFriendList,
              currentUser: widget.currentUser);
        } else if (state is ApprovedFriendsLoading) {
          return const Center(child: DefaultLoading());
        }
        return NoUserFoundWidget(currentUser: widget.currentUser);
      },
    );
  }
}
