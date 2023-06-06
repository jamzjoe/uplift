import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/user_notif_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
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
  int paginationLimit = 10;
  bool showPopUp = true;
  List<UserNotifModel> notifications = [];

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserJoinedModel userJoinedModel = widget.user;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBody: true,
        body: PostListItem(userJoinedModel: userJoinedModel),
        floatingActionButton: SpeedDial(
          spaceBetweenChildren: 10,
          overlayOpacity: 0.5,
          overlayColor: darkColor,
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
          animatedIcon: AnimatedIcons.add_event,
          isOpenOnStart: true,
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
                context.pushNamed('friend_suggest',
                    extra: widget.user.userModel);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _scrollListener() {
    if (scrollController.keepScrollOffset) {
      setState(() {
        showPopUp = false;
      });
    }
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  void loadMoreData() {
    setState(() {
      paginationLimit += 10;
    });
    BlocProvider.of<GetPrayerRequestBloc>(context).add(GetPostRequestList(
      limit: paginationLimit,
      widget.user.user.uid,
    ));
  }
}
