import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/data/user_comment_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/utils/widgets/comment_shimmer_item.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/just_now.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class CommentView extends StatefulWidget {
  const CommentView(
      {super.key,
      required this.currentUser,
      required this.prayerRequestPostModel,
      required this.postOwner,
      required this.postModel});
  final UserModel currentUser;
  final PrayerRequestPostModel prayerRequestPostModel;
  final UserModel postOwner;
  final PostModel postModel;

  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<String> comments = [];

  Widget _showCommentBottomSheet() {
    final prayerRequestPostModel = widget.prayerRequestPostModel;
    final postOwner = widget.postOwner;
    final currentUser = widget.currentUser;

    return Container(
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Hero(
                      tag: 'profile',
                      child: ProfilePhoto(user: widget.currentUser, size: 20)),
                ),
                suffixIcon: IconButton(
                    onPressed: () {
                      BlocProvider.of<EncourageBloc>(context).add(
                          AddEncourageEvent(
                              prayerRequestPostModel.postId!,
                              _commentController.text,
                              postOwner,
                              currentUser,
                              _commentController,
                              context,
                              _scrollController));
                    },
                    icon: const Icon(CupertinoIcons.paperplane_fill)),
                hintText: 'Add a comment',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CommentPage(
            scrollController: _scrollController,
            postModel: widget.postModel,
            postOwner: widget.postOwner),
      ),
      bottomSheet: _showCommentBottomSheet(),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class CommentPage extends StatelessWidget {
  const CommentPage({
    super.key,
    required ScrollController scrollController,
    required this.postModel,
    required this.postOwner,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final PostModel postModel;
  final UserModel postOwner;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EncourageBloc, EncourageState>(
      builder: (context, state) {
        log(state.toString());
        if (state is LoadingEncouragesSuccess) {
          final encourages = state.encourages;
          if (encourages.isEmpty) {
            return Center(
              child: Column(
                children: const [
                  Expanded(
                    child: Center(
                      child: DefaultText(
                          text: 'No Encourage Yet', color: secondaryColor),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: HeaderText(
                      text: '${encourages.length} Encourages',
                      color: secondaryColor),
                ),
              ),
              Expanded(
                  child: ListView.separated(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 100),
                separatorBuilder: (context, index) => Divider(
                  color: lightColor.withOpacity(0.2),
                  thickness: 0.5,
                ),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                controller: _scrollController,
                itemCount: encourages.length,
                itemBuilder: (context, index) {
                  return CommentItem(encourages: encourages, index: index);
                },
              )),
            ],
          );
        } else if (state is LoadingEncourages) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: lightColor.withOpacity(0.2),
              thickness: 0.5,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              return const CommentShimmerItem();
            },
          );
        }
        return const Center(
            child: DefaultText(
                text: 'Something went wron!.', color: secondaryColor));
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.encourages,
    required this.index,
  });

  final List<UserCommentModel> encourages;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        minVerticalPadding: 0,
        leading: ProfilePhoto(
          user: encourages[index].userModel,
          radius: 60,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HeaderText(
                text: encourages[index].userModel.displayName!,
                color: secondaryColor,
                size: 16),
            SmallText(
                text: DateFeature().formatDateTime(
                    encourages[index].commentModel.createdAt!.toDate()),
                color: lightColor)
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmallText(
                text: encourages[index].commentModel.commentText!,
                color: secondaryColor),
          ],
        ),
      ),
    );
  }
}
