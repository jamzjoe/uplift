import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';

class PostItemView extends StatefulWidget {
  const PostItemView(
      {super.key, required this.postModel, required this.userModel});
  final PostModel postModel;
  final UserModel userModel;

  @override
  State<PostItemView> createState() => _PostItemViewState();
}

class _PostItemViewState extends State<PostItemView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: PostItem(
                postModel: widget.postModel,
                user: widget.userModel,
                fullView: true)));
  }
}
