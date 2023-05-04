import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';

import 'friend_suggestions_screen.dart';
import 'friends_item.dart';
import 'search_bar.dart';

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
      child: Column(
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
                children: const [
                  DefaultText(text: 'Your friends', color: secondaryColor),
                  SizedBox(width: 5),
                  HeaderText(text: '1,500', color: primaryColor, size: 18)
                ],
              ),
              const DefaultText(text: 'See all', color: linkColor)
            ],
          ),
          const FriendsItem(),
          const FriendsItem(),
          const FriendsItem(),
          const FriendsItem(),
          const FriendsItem(),
          defaultSpace,
          FriendSuggestions(
            currentUser: widget.currentUser,
          )
        ],
      ),
    );
  }

  void searchFriend(String value) {}
}
