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

  final ScrollController _scrollController = ScrollController();
  bool _innerBoxIsScrolled = false;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    filteredPosts = List.from(widget.posts);
    _scrollController.addListener(_updateScrollPosition);

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
        setState(() {
          community = filteredPosts;
        });
      }
    });
  }

  final TextEditingController controller = TextEditingController();

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
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/header_bg.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              floating: true,
              forceElevated: innerBoxIsScrolled,
              toolbarHeight: 120,
              backgroundColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
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
                                      color: whiteColor,
                                      size: 16,
                                    ),
                                    HeaderText(
                                      text:
                                          '${capitalizeFirstLetter('${widget.userModel.displayName}')},',
                                      color: whiteColor,
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
                                alignment: AlignmentDirectional.bottomStart,
                                child: IconButton(
                                  onPressed: () {
                                    goToNotificationScreen(
                                      widget.userModel.userId!,
                                      context,
                                      widget.userModel,
                                    );
                                  },
                                  icon: const Icon(
                                    Ionicons.notifications,
                                    size: 28,
                                    color: whiteColor,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomContainer(
                      color: Colors.black.withOpacity(0.2),
                      widget: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: controller,
                        onChanged: filterPosts,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search for Topics',
                          hintStyle:
                              TextStyle(color: whiteColor.withOpacity(0.5)),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(CupertinoIcons.search,
                                color: whiteColor),
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
                unselectedLabelColor: _innerBoxIsScrolled
                    ? lighter.withOpacity(0.5)
                    : whiteColor.withOpacity(0.8),
                labelColor: _innerBoxIsScrolled ? lighter : whiteColor,
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

  void goToNotificationScreen(
      String userID, BuildContext context, UserModel userModel) {
    BlocProvider.of<NotificationBloc>(context).add(MarkAllAsRead(userID));
    context.pushNamed('notification', extra: userModel);
  }

  void _updateScrollPosition() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels <= 0) {
        setState(() {
          _innerBoxIsScrolled = false;
        });
      } else {
        setState(() {
          _innerBoxIsScrolled = true;
        });
      }
    }
  }
}

