import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PostListView extends StatefulWidget {
  const PostListView({
    Key? key,
    required this.postList,
  }) : super(key: key);

  final List<PostModel> postList;

  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PostModel> filteredPostList = [];
  bool _isDisposed = false;
  List<String> tabTitle = [
    "All",
    "Popular",
    "Personal",
    "Family",
    "Community",
    "Global",
    "Gratitude",
    "Healing",
    "Faith",
    "Vocational",
    "Special",
    "Result"
  ];
  @override
  void initState() {
    filteredPostList = widget.postList;
    _tabController = TabController(
      length: 12, // Number of tabs
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the tab controller
    _isDisposed = true;
    super.dispose();
  }

  void searchPosts(String? query) {
    if (_isDisposed) return; // Check if the widget is still mounted
    setState(() {
      filteredPostList = widget.postList.where((post) {
        return post.prayerRequestPostModel.text != null &&
                post.prayerRequestPostModel.text!
                    .toLowerCase()
                    .contains(query?.toLowerCase() ?? '') ||
            post.prayerRequestPostModel.title != null &&
                post.prayerRequestPostModel.title!
                    .toLowerCase()
                    .contains(query?.toLowerCase() ?? '') ||
            post.prayerRequestPostModel.name != null &&
                post.prayerRequestPostModel.name!
                    .toLowerCase()
                    .contains(query?.toLowerCase() ?? '') ||
            post.userModel.displayName != null &&
                post.userModel.displayName!
                    .toLowerCase()
                    .contains(query?.toLowerCase() ?? '') ||
            post.userModel.phoneNumber != null &&
                post.userModel.phoneNumber!
                    .toLowerCase()
                    .contains(query?.toLowerCase() ?? '') ||
            post.userModel.emailAddress != null &&
                post.userModel.emailAddress!
                    .toLowerCase()
                    .contains(query?.toLowerCase() ?? '');
      }).toList();
    });
  }

  void searchPopular() {
    if (_isDisposed) return;

    searchPosts(''); // Check if the widget is still mounted
    setState(() {
      filteredPostList.sort((a, b) =>
          (b.prayerRequestPostModel.reactions?.users?.length ?? 0).compareTo(
              a.prayerRequestPostModel.reactions?.users?.length ?? 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) async {
              if (value.isEmpty) {
                _tabController.animateTo(0);
              } else {
                searchPosts(value);
                _tabController.animateTo(11);
              }
            },
            decoration: const InputDecoration(
              hintText: 'Search prayer intentions, emails, and etc.',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        TabBar(
          onTap: (value) {
            switch (value) {
              case 0:
                searchPosts('');
                break;
              case 1:
                searchPopular();
                break;
              case 2:
                searchPosts(tabTitle[value]);
                break;
              case 3:
                searchPosts(tabTitle[value]);
                break;
              case 4:
                searchPosts(tabTitle[value]);
                break;
              case 5:
                searchPosts(tabTitle[value]);
                break;
              case 6:
                searchPosts(tabTitle[value]);
                break;
              case 7:
                searchPosts(tabTitle[value]);
                break;
              case 8:
                searchPosts(tabTitle[value]);
                break;
              case 9:
                searchPosts(tabTitle[value]);
                break;
              case 10:
                searchPosts(tabTitle[value]);
                break;
            }
          },
          isScrollable: true,
          controller: _tabController,
          tabs: [
            ...tabTitle.map((e) => Tab(
                  text: e,
                ))
          ],
        ),
        Expanded(
          child: filteredPostList.isEmpty
              ? const Center(
                  child: SmallText(text: 'No result found', color: darkColor))
              : ListView.builder(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 150),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: filteredPostList.length,
                  itemBuilder: (context, index) => PostItem(
                    allPost: widget.postList,
                    postModel: filteredPostList[index],
                    user: filteredPostList[index].userModel,
                    fullView: false,
                  ),
                ),
        ),
      ],
    );
  }
}
