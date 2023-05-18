import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/comment_view.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/utils/widgets/comment_shimmer_item.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

class FullCommentView extends StatelessWidget {
  const FullCommentView(
      {super.key,
      required this.prayerRequestPostModel,
      required this.postModel,
      required this.userModel,
      required this.currentUser});
  final PrayerRequestPostModel prayerRequestPostModel;
  final PostModel postModel;
  final UserModel userModel;
  final UserModel currentUser;
  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final ScrollController scrollController = ScrollController();
    return Scaffold(
        bottomSheet: SingleChildScrollView(
          child: Container(
            color: whiteColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ProfilePhoto(user: currentUser, size: 20),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            BlocProvider.of<EncourageBloc>(context).add(
                                AddEncourageEvent(
                                    prayerRequestPostModel.postId!,
                                    commentController.text,
                                    userModel,
                                    currentUser,
                                    commentController,
                                    context,
                                    scrollController));
                          },
                          icon: const Icon(CupertinoIcons.paperplane_fill)),
                      hintText: 'Add a comment',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 100),
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            child: Column(
              children: [
                PostItem(postModel: postModel, user: userModel, fullView: true),
                BlocBuilder<EncourageBloc, EncourageState>(
                  builder: (context, state) {
                    if (state is LoadingEncouragesSuccess) {
                      return SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                              state.encourages.length,
                              (index) => CommentItem(
                                  encourages: state.encourages, index: index),
                              growable: true),
                        ),
                      );
                    }
                    return Column(
                      children: List.generate(
                          10, (index) => const CommentShimmerItem()),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
