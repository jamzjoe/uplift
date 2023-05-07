import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_list.dart';
import 'package:uplift/utils/widgets/header_text.dart';

class YourFriendsScreen extends StatefulWidget {
  const YourFriendsScreen({super.key, required this.user});
  final User user;

  @override
  State<YourFriendsScreen> createState() => _YourFriendsScreenState();
}

class _YourFriendsScreenState extends State<YourFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'All friends', color: secondaryColor),
      ),
      body: FriendsList(currentUser: widget.user),
    );
  }
}
