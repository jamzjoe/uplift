import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/friend_request_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/search_bar.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';

import 'friend_suggestions.dart';

class FriendRequestList extends StatefulWidget {
  const FriendRequestList({
    super.key,
  });

  @override
  State<FriendRequestList> createState() => _FriendRequestListState();
}

class _FriendRequestListState extends State<FriendRequestList> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  DefaultText(text: 'Friend request', color: secondaryColor),
                  SizedBox(width: 5),
                  HeaderText(text: '45', color: primaryColor, size: 18)
                ],
              ),
              const DefaultText(text: 'See all', color: linkColor)
            ],
          ),
          const FriendRequestItem(),
          const FriendRequestItem(),
          const FriendRequestItem(),
          defaultSpace,
          defaultSpace,
          SearchBar(
            controller: searchController,
            onFieldSubmitted: (p0) {},
            hint: 'Search here...',
          ),
          const FriendSuggestions()
        ],
      ),
    );
  }
}
