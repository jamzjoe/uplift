import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/user_notif_model.dart';
import 'post_screen/presentation/page/post_list_item.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key, required this.user}) : super(key: key);
  final UserJoinedModel user;

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool isPosting = false;
  int badgeCount = 0;
  bool showPopUp = true;
  List<UserNotifModel> notifications = [];

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserJoinedModel userJoinedModel = widget.user;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBody: true,
        body: PostListItem(
            userJoinedModel: userJoinedModel, controller: scrollController),
        floatingActionButton: SpeedDial(
          spaceBetweenChildren: 10,
          overlayOpacity: 0.5,
          overlayColor: darkColor,
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
          animatedIcon: AnimatedIcons.add_event,
          children: [
            SpeedDialChild(
              child: const Icon(CupertinoIcons.paperplane, color: whiteColor),
              backgroundColor: Colors.blue,
              label: 'New Prayer Intentions',
              labelStyle: const TextStyle(fontSize: 14),
              onTap: () {
                context.pushNamed('post_field', extra: widget.user);
              },
            ),
            SpeedDialChild(
              child: const Icon(CupertinoIcons.person_2, color: whiteColor),
              backgroundColor: Colors.orange,
              label: 'Find Friends',
              labelStyle: const TextStyle(fontSize: 14),
              onTap: () {
                log('Tap');
                context.pushNamed('friend_suggest',
                    extra: widget.user.userModel);
              },
            ),
          ],
        ),
      ),
    );
  }
}
