import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import '../search_bar.dart';
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: BlocBuilder<ApprovedFriendsBloc, ApprovedFriendsState>(
        builder: (context, state) {
          log(state.toString());
          if (state is ApprovedFriendsSuccess) {
            log(state.approvedFriendsList.length.toString());

            return ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                SearchBar(
                  controller: searchController,
                  onFieldSubmitted: (p0) {},
                  hint: 'Search your friend here...',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const DefaultText(
                            text: 'Your friends', color: secondaryColor),
                        const SizedBox(width: 5),
                        HeaderText(
                            text: state.approvedFriendsList.length.toString(),
                            color: primaryColor,
                            size: 18)
                      ],
                    ),
                    GestureDetector(
                        onTap: () => context.pushNamed('friends-list'),
                        child: const DefaultText(
                            text: 'See all', color: linkColor))
                  ],
                ),
                ...state.approvedFriendsList.map((e) => FriendsItem(
                      friendShipModel: e,
                    )),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  void searchFriend(String value) {}
}
