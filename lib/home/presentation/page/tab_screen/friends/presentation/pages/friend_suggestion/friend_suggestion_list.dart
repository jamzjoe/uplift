import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';

import 'add_friend_item.dart';

class FriendSuggestionList extends StatefulWidget {
  const FriendSuggestionList({
    super.key,
    required this.users,
    required this.currentUser,
    required this.context,
  });
  final List<UserModel> users;
  final UserModel currentUser;
  final BuildContext context;

  @override
  State<FriendSuggestionList> createState() => _FriendSuggestionListState();
}

class _FriendSuggestionListState extends State<FriendSuggestionList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(widget.users[index].userId!),
            child: AddFriendItem(
                user: widget.users[index],
                currentUser: widget.currentUser,
                screenContext: widget.context),
          );
        },
        itemCount: widget.users.length);
  }
}
