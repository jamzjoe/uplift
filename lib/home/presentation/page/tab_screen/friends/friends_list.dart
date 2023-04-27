import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/friend_suggestions.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/friends_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/search_bar.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({
    super.key,
  });

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
          const FriendSuggestions()
        ],
      ),
    );
  }

  void searchFriend(String value) {}
}
