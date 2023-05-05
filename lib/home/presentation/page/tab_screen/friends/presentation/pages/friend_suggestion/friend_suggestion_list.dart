import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

import 'add_friend_item.dart';

class FriendSuggestionList extends StatelessWidget {
  const FriendSuggestionList({
    super.key,
    required this.users,
    required this.currentUser,
  });
  final List<UserModel> users;
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        Visibility(
            visible: users.isEmpty,
            child: const Center(
                child: NoDataMessage(text: 'No user found in UpLift'))),
        ...users.map((e) => AddFriendItem(
              user: e,
              currentUser: currentUser,
            ))
      ],
    );
  }
}
