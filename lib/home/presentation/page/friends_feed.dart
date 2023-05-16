import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';

class FriendsFeed extends StatefulWidget {
  const FriendsFeed({super.key, required this.userModel});
  final UserModel userModel;

  @override
  State<FriendsFeed> createState() => _FriendsFeedState();
}

class _FriendsFeedState extends State<FriendsFeed> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
