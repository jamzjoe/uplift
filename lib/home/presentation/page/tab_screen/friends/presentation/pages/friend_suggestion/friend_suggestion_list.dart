import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestions_screen.dart';

import 'add_friend_item.dart';

class FriendSuggestionList extends StatefulWidget {
  const FriendSuggestionList({
    super.key,
    required this.users,
    required this.currentUser,
  });
  final List<UserModel> users;
  final UserModel currentUser;

  @override
  State<FriendSuggestionList> createState() => _FriendSuggestionListState();
}

class _FriendSuggestionListState extends State<FriendSuggestionList> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return AddFriendItem(
              user: widget.users[index], currentUser: widget.currentUser);
        },
        separatorBuilder: (context, index) {
          return Divider(thickness: .5, color: secondaryColor.withOpacity(0.2));
        },
        itemCount: widget.users.length);
  }
}
