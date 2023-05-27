import 'package:flutter/material.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';

class PostListView extends StatefulWidget {
  const PostListView({
    super.key,
    required this.postList,
  });

  final List<PostModel> postList;

  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  List<PostModel> filteredPosts = [];

  @override
  void initState() {
    filteredPosts = widget.postList;
    super.initState();
  }

  void _search(String query) {
    setState(() {
      filteredPosts = widget.postList
          .where((post) =>
              post.userModel.displayName!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              post.prayerRequestPostModel.text!
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 150),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ...filteredPosts.map(
          (post) => PostItem(
            postModel: post,
            user: post.userModel,
            fullView: false,
          ),
        ),
      ],
    );
  }
}
