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
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_list_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestion_horizontal.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/capitalize.dart';
import 'package:uplift/utils/widgets/date_widget.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';
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
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    filteredPosts = List.from(widget.posts);
  }

  void filterPosts(String query) {
    tabController.animateTo(0);
    setState(() {
      if (query.isEmpty) {
        filteredPosts = List.from(widget.posts);
      } else {
        filteredPosts = widget.posts.where((post) {
          return post.prayerRequestPostModel.text
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true ||
              post.prayerRequestPostModel.title
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true ||
              post.prayerRequestPostModel.name
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true ||
              post.userModel.displayName
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true ||
              post.userModel.phoneNumber
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true ||
              post.userModel.emailAddress
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true;
        }).toList();
      }
    });
  }

  void myPost() {
    setState(() {
      filteredPosts = widget.posts
          .where((element) =>
              element.prayerRequestPostModel.userId == widget.userModel.userId)
          .toList();
    });
  }

  void community() {
    setState(() {
      filteredPosts = widget.posts;
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
          });
        }
      },
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
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
              toolbarHeight: 130,
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
                                        size: 16),
                                    HeaderText(
                                      text:
                                          "${capitalizeFirstLetter('${widget.userModel.displayName}')},",
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
                                        widget.userModel);
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
                      color: Colors.grey.shade100,
                      widget: TextField(
                        controller: controller,
                        onChanged: filterPosts,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search for Topics',
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(CupertinoIcons.search),
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
                unselectedLabelColor: innerBoxIsScrolled
                    ? lighter.withOpacity(0.5)
                    : whiteColor.withOpacity(0.8),
                labelColor: innerBoxIsScrolled ? lighter : whiteColor,
                automaticIndicatorColorAdjustment: true,
                onTap: (value) {
                  if (value == 0) {
                    community();
                  } else if (value == 1) {
                    myPost();
                  }
                },
                tabs: const [
                  Tab(text: 'Community'),
                  Tab(text: 'My Prayer Intentions'),
                ],
              ),
            ),
          ],
          body: RefreshIndicator(
            onRefresh: () async {
              if (DefaultTabController.of(context).index == 0) {
                community();
              } else if (DefaultTabController.of(context).index == 1) {
                myPost();
              }
              BlocProvider.of<GetPrayerRequestBloc>(context)
                  .add(RefreshPostRequestList(widget.userModel.userId!));
            },
            child: ListView(
              children: [
                Column(
                  children: [
                    FriendSuggestionHorizontal(
                        currentUser: widget.userModel,
                        userJoinedModel: widget.widget.userJoinedModel),
                  ],
                ),
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 120),
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredPosts.length,
                  itemBuilder: (context, index) {
                    if (index <= filteredPosts.length) {
                      final e = filteredPosts[index];
                      return PostItem(
                        allPost: filteredPosts,
                        postModel: e,
                        user: widget.userModel,
                        fullView: false,
                      );
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 300,
                        child: const Center(
                          child:
                              NoDataMessage(text: 'No prayer intention found.'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
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
}
