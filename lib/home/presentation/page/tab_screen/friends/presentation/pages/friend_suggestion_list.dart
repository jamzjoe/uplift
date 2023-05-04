import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';

import 'add_friend_item.dart';

class FriendSuggestionList extends StatelessWidget {
  const FriendSuggestionList({
    super.key,
    required this.users, required this.currentUser,
  });
  final List<UserModel> users;
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [...users.map((e) => AddFriendItem(user: e, currentUser: currentUser,))],
    );
  }
}
