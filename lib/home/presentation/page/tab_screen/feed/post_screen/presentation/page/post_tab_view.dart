import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/feed_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_list_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestion_horizontal.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

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

class _PostTabViewState extends State<PostTabView> {
  late List<PostModel> filteredPosts;

  @override
  void initState() {
    super.initState();
    filteredPosts = List.from(widget.posts);
  }

  void filterPosts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPosts = List.from(widget.posts);
      } else {
        filteredPosts = widget.posts.where((post) {
          return post.prayerRequestPostModel.text != null &&
                  post.prayerRequestPostModel.text!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
              post.prayerRequestPostModel.title != null &&
                  post.prayerRequestPostModel.title!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
              post.prayerRequestPostModel.name != null &&
                  post.prayerRequestPostModel.name!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
              post.userModel.displayName != null &&
                  post.userModel.displayName!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
              post.userModel.phoneNumber != null &&
                  post.userModel.phoneNumber!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
              post.userModel.emailAddress != null &&
                  post.userModel.emailAddress!
                      .toLowerCase()
                      .contains(query.toLowerCase() ?? '');
        }).toList();
      }
    });
  }

  void myPost() {
    setState(() {
      filteredPosts = widget.posts
          .where((element) => element.prayerRequestPostModel.userId == userID)
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  CustomContainer(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    color: whiteColor,
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
                  FriendSuggestionHorizontal(currentUser: widget.userModel),
                ],
              ),
            ),
            TabBar(
              indicatorColor: primaryColor,
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
                Tab(text: 'My Prayers'),
              ],
            ),
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 120),
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredPosts.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const PostStatusWidget();
                } else if (index <= filteredPosts.length) {
                  final e = filteredPosts[index - 1];
                  return PostItem(
                    allPost: filteredPosts,
                    postModel: e,
                    user: widget.userModel,
                    fullView: false,
                  );
                } else {
                  return const NoDataMessage(
                      text: 'No prayer intention found.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
