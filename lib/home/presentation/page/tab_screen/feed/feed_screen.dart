import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import 'post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'post_screen/presentation/bloc/post_prayer_request/post_prayer_request_bloc.dart';
import 'post_screen/presentation/page/post_list_item.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.user});
  final User user;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool isPosting = false;
  int badgeCount = 0;
  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    return Scaffold(
      backgroundColor: const Color(0xffE9EBEE),
      extendBody: true,
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationLoadingSuccess) {
            setState(() {
              badgeCount = state.notifications.length;
            });
          }
        },
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: whiteColor,
                  title: const Image(
                    image: AssetImage('assets/uplift-logo.png'),
                    width: 80,
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: CustomSearchDelegate());
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 30,
                        )),
                    Badge.count(
                      count: badgeCount,
                      alignment: AlignmentDirectional.bottomStart,
                      child: IconButton(
                          onPressed: () =>
                              goToNotificationScreen(widget.user.uid),
                          icon: const Icon(
                            Icons.notifications,
                            size: 30,
                          )),
                    ),
                  ],
                )
              ];
            },
            body: RefreshIndicator(
              onRefresh: () async =>
                  BlocProvider.of<GetPrayerRequestBloc>(context)
                      .add(RefreshPostRequestList()),
              child: Column(
                children: [
                  Expanded(child: PostListItem(user: user)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goToNotificationScreen(String userID) {
    context.pushNamed('notification');
  }
}

class PostStatusWidget extends StatelessWidget {
  const PostStatusWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostPrayerRequestBloc, PostPrayerRequestState>(
      builder: (context, state) {
        if (state is PostPrayerRequestLoading) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            color: whiteColor,
            child: Row(
              children: const [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: linkColor,
                  ),
                ),
                SizedBox(width: 15),
                SmallText(
                    text: 'Posting your prayer request...',
                    color: secondaryColor)
              ],
            ),
          );
        } else if (state is Posted) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            color: whiteColor,
            child: Row(
              children: const [
                Icon(CupertinoIcons.check_mark_circled_solid,
                    color: linkColor, size: 20),
                SizedBox(width: 15),
                SmallText(text: 'Prayer request posted.', color: secondaryColor)
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = ['Test', 'Joe'];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Ionicons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Ionicons.search));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var each in searchTerms) {
      if (each.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(each);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListTile(
                  dense: true,
                  title: DefaultText(
                      text: matchQuery[index], color: secondaryColor)),
            ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var each in searchTerms) {
      if (each.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(each);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListTile(
                  dense: true,
                  title: DefaultText(
                      text: matchQuery[index], color: secondaryColor)),
            ));
  }
}
