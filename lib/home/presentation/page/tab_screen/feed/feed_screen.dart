import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            context.pushNamed('post_field', extra: userJoinedModel);
          },
          child: const Icon(
            CupertinoIcons.add,
            color: whiteColor,
          ),
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
