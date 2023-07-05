import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_shimmer_loading.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_tab_view.dart';
import 'package:uplift/utils/widgets/default_text.dart';

import '../bloc/post_prayer_request/post_prayer_request_bloc.dart';

class PostListItem extends StatefulWidget {
  const PostListItem({
    Key? key,
    required this.userJoinedModel, required this.controller,
  }) : super(key: key);

  final UserJoinedModel userJoinedModel;
  final ScrollController controller;
  @override
  State<PostListItem> createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  @override
  Widget build(BuildContext context) {
    final UserModel userModel = widget.userJoinedModel.userModel;
    return BlocBuilder<GetPrayerRequestBloc, GetPrayerRequestState>(
      builder: (context, state) {
        if (state is LoadingPrayerRequesListSuccess) {
          final posts = state.prayerRequestPostModel;
          if (posts.isEmpty) {
            return Center(
              child: EndOfPostWidget(
                isEmpty: true,
                user: widget.userJoinedModel,
              ),
            );
          }
          return PostTabView(
              scrollController: widget.controller,
              posts: posts, userModel: userModel, widget: widget);
        } else if (state is LoadingPrayerRequesList ||
            state is NoInternetConnnection) {
          return const PostShimmerLoading();
        }
        return const PostShimmerLoading();
      },
    );
  }
}

class EndOfPostWidget extends StatelessWidget {
  const EndOfPostWidget({
    Key? key,
    required this.isEmpty,
    required this.user,
  }) : super(key: key);

  final bool isEmpty;
  final UserJoinedModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Visibility(
          visible: isEmpty,
          child: BlocBuilder<PostPrayerRequestBloc, PostPrayerRequestState>(
            builder: (context, state) {
              final isLoading = state is PostPrayerRequestLoading;
              return ElevatedButton.icon(
                onPressed: () {
                  context.pushNamed('post_field', extra: user);
                },
                icon: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: whiteColor,
                        ),
                      )
                    : const Icon(CupertinoIcons.pencil_circle_fill,
                        color: whiteColor),
                label: DefaultText(
                  text: isLoading
                      ? 'Posting your prayer request..'
                      : 'New Prayer Intentions',
                  color: whiteColor,
                ),
              );
            },
          ),
        ),
        Visibility(
          visible: isEmpty,
          child: TextButton.icon(
            onPressed: () {
              context.pushNamed('friend_suggest', extra: user.userModel);
            },
            icon: const Icon(CupertinoIcons.person_add_solid,
                color: primaryColor),
            label: const DefaultText(text: 'Find friends', color: primaryColor),
          ),
        ),
      ],
    );
  }
}
