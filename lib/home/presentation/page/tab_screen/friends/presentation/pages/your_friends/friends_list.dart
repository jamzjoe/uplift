import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/search_bar.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';
import 'friends_item.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({
    super.key,
    required this.currentUser,
  });
  final User currentUser;

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
          if (state.approvedFriendList.isEmpty) {
            return const Center(
                child: NoDataMessage(text: 'No friends yet...'));
          }
          return ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            children: [
              SearchBar(
                onFieldSubmitted: (query) {
                  BlocProvider.of<ApprovedFriendsBloc>(context)
                      .add(SearchApprovedFriend(query));
                },
                hint: 'Search your friend here...',
              ),
              ...state.approvedFriendList.map((e) => FriendsItem(user: e))
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void searchFriend(String value) {}
}
