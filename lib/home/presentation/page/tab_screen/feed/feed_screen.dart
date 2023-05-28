import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/user_notif_model.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/utils/widgets/small_text.dart';
import 'post_screen/presentation/bloc/post_prayer_request/post_prayer_request_bloc.dart';
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
    final User user = widget.user.user;
    final UserJoinedModel userJoinedModel = widget.user;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: const Image(
          image: AssetImage('assets/uplift-logo.png'),
          width: 80,
        ),
        actions: [
          StreamBuilder<Map<String, dynamic>>(
              stream: NotificationRepository().notificationListener(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final count = snapshot.data!['length'];
                  return Badge.count(
                    isLabelVisible: count != 0,
                    count: count,
                    alignment: AlignmentDirectional.bottomStart,
                    child: IconButton(
                      onPressed: () {
                        goToNotificationScreen(user.uid);
                      },
                      icon: const Icon(
                        Ionicons.notifications,
                        size: 25,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }),
        ],
      ),
      body: SafeArea(
          maintainBottomViewPadding: true,
          child: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<GetPrayerRequestBloc>(context)
                  .add(RefreshPostRequestList(widget.user.user.uid));
            },
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                return PostListItem(userJoinedModel: userJoinedModel);
              },
            ),
          )),
    );
  }

  void goToNotificationScreen(String userID) {
    BlocProvider.of<NotificationBloc>(context).add(MarkAllAsRead(userID));
    context.pushNamed('notification', extra: widget.user.userModel);
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

class PostStatusWidget extends StatelessWidget {
  const PostStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostPrayerRequestBloc, PostPrayerRequestState>(
      builder: (context, state) {
        if (state is PostPrayerRequestLoading) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            color: whiteColor,
            child: Row(
              children: const [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: SpinKitFadingCircle(
                    color: primaryColor,
                    size: 25,
                  ),
                ),
                SizedBox(width: 15),
                SmallText(
                  text: 'Posting your prayer request...',
                  color: secondaryColor,
                ),
              ],
            ),
          );
        } else if (state is Posted) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            color: whiteColor,
            child: Row(
              children: const [
                Icon(
                  Ionicons.checkmark_done_circle,
                  color: linkColor,
                  size: 25,
                ),
                SizedBox(width: 15),
                SmallText(
                  text: 'Prayer request posted.',
                  color: secondaryColor,
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
