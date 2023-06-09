import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_list_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/tab_list_view.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/capitalize.dart';
import 'package:uplift/utils/widgets/date_widget.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PostTabView extends StatefulWidget {
  const PostTabView({
    Key? key,
    required this.posts,
    required this.userModel,
    required this.widget,
  }) : super(key: key);

  final List<PostModel> posts;
  final UserModel userModel;
  final PostListItem widget;

  @override
  _PostTabViewState createState() => _PostTabViewState();
}

class _PostTabViewState extends State<PostTabView>
    with SingleTickerProviderStateMixin {
  late List<PostModel> filteredPosts;
  List<PostModel> community = [];
  List<PostModel> myPost = [];
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    filteredPosts = List.from(widget.posts);
    fetchMyPost(filteredPosts);
    fetchCommunity(filteredPosts);
    super.initState();
  }

  void fetchMyPost(List<PostModel> updatedPost) {
    myPost = updatedPost
        .where((element) =>
            element.prayerRequestPostModel.userId == widget.userModel.userId)
        .toList();
  }

  void fetchCommunity(List<PostModel> updatedPost) {
    community = updatedPost;
  }

  void filterPosts(String query) {
    tabController.animateTo(0);
    setState(() {
      if (query.isEmpty) {
        filteredPosts = List.from(widget.posts);
      } else {
        filteredPosts = widget.posts.where((post) {
          final prayerRequestPostModel = post.prayerRequestPostModel;
          final userModel = post.userModel;

          return (prayerRequestPostModel.text
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true) ||
              (prayerRequestPostModel.title
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true) ||
              (prayerRequestPostModel.name
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true) ||
              (userModel.displayName
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true) ||
              (userModel.phoneNumber
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true) ||
              (userModel.emailAddress
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true);
        }).toList();
        community = filteredPosts;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetPrayerRequestBloc, GetPrayerRequestState>(
      listener: (context, state) {
        if (state is LoadingPrayerRequesListSuccess) {
          setState(() {
            filteredPosts = state.prayerRequestPostModel;
            fetchCommunity(state.prayerRequestPostModel);
            fetchMyPost(state.prayerRequestPostModel);
          });
        }
      },
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              flexibleSpace: const FlexibleSpaceBar(),
              floating: true,
              forceElevated: innerBoxIsScrolled,
              toolbarHeight: 170,
              backgroundColor: whiteColor,
              title: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(
                            image: AssetImage('assets/uplift_colored_logo.png'),
                            width: 60),
                        Row(
                          children: [
                            SmallText(
                                text: 'In partnership with ', color: darkColor),
                            Image(
                                image: AssetImage(
                                    'assets/live_the_faith_logo.png'),
                                width: 40),
                          ],
                        )
                      ],
                    ),
                    defaultSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ProfilePhoto(user: widget.userModel),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const HeaderText(
                                      text: 'Hello ',
                                      color: darkColor,
                                      size: 16,
                                    ),
                                    HeaderText(
                                      text:
                                          '${capitalizeFirstLetter('${widget.userModel.displayName}')},',
                                      color: primaryColor,
                                      size: 20,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    TextDateWidget(
                                      date: DateTime.now(),
                                      fillers: 'Today is',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        StreamBuilder<Map<String, dynamic>>(
                          stream: NotificationRepository()
                              .notificationListener(widget.userModel.userId!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final count = snapshot.data!['length'];
                              return Badge.count(
                                isLabelVisible: count != 0,
                                count: count,
                                alignment: AlignmentDirectional.topEnd,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    goToNotificationScreen(
                                      widget.userModel.userId!,
                                      context,
                                    );
                                  },
                                  icon: Icon(
                                    Ionicons.notifications,
                                    size: 28,
                                    color: darkColor.withOpacity(0.7),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                    defaultSpace,
                    CustomContainer(
                      color: Colors.black.withOpacity(0.1),
                      widget: TextField(
                        style: TextStyle(color: lighter),
                        onChanged: filterPosts,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              'Search prayer intentions, names, email, and etc.',
                          hintStyle:
                              TextStyle(color: darkColor.withOpacity(0.5)),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(CupertinoIcons.search,
                                color: darkColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: tabController,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                indicatorColor: primaryColor,
                unselectedLabelColor: darkColor.withOpacity(0.5),
                labelColor: darkColor,
                automaticIndicatorColorAdjustment: true,
                onTap: (value) {
                  // Handle tab selection
                },
                tabs: const [
                  Tab(text: 'Community'),
                  Tab(text: 'My Prayer Intentions'),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: tabController,
            children: [
              TabListView(widget: widget, filteredPosts: community),
              TabListView(widget: widget, filteredPosts: myPost),
            ],
          ),
        ),
      ),
    );
  }

  void goToNotificationScreen(String userID, BuildContext context) {
    BlocProvider.of<NotificationBloc>(context).add(MarkAllAsRead(userID));
    context.pushNamed('notification', extra: widget.userModel);
  }
}
