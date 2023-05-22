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
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

class FullCommentView extends StatefulWidget {
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
  State<FullCommentView> createState() => _FullCommentViewState();
}

final ScrollController scrollController = ScrollController();

class _FullCommentViewState extends State<FullCommentView> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
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
                        child: ProfilePhoto(user: widget.currentUser, size: 20),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            BlocProvider.of<EncourageBloc>(context).add(
                                AddEncourageEvent(
                                    widget.prayerRequestPostModel.postId!,
                                    commentController.text,
                                    widget.userModel,
                                    widget.currentUser,
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
                PostItem(
                    postModel: widget.postModel,
                    user: widget.userModel,
                    fullView: true),
                BlocBuilder<EncourageBloc, EncourageState>(
                  builder: (context, state) {
                    if (state is LoadingEncouragesSuccess) {
                      if (state.encourages.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(30),
                          child: DefaultText(
                              text: 'No encouragement yet...',
                              color: secondaryColor),
                        );
                      }
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
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
