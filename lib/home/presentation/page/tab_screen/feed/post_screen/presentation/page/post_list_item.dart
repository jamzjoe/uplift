import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_field.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_shimmer_loading.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestion_horizontal.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../feed_screen.dart';
import '../bloc/post_prayer_request/post_prayer_request_bloc.dart';
import 'post_item.dart';

class PostListItem extends StatefulWidget {
  const PostListItem({
    super.key,
    required this.userJoinedModel,
  });
  final UserJoinedModel userJoinedModel;

  @override
  State<PostListItem> createState() => _PostListItemState();
}

List<UserModel> suggestions = [];

class _PostListItemState extends State<PostListItem> {
  @override
  Widget build(BuildContext context) {
    final UserModel userModel = widget.userJoinedModel.userModel;
    final User user = widget.userJoinedModel.user;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeaderText(
                            text: 'Hello ${userModel.displayName},',
                            color: secondaryColor),
                        const SmallText(
                            text: 'What would you like us to pray for?',
                            color: secondaryColor),
                      ],
                    ),
                  ),
                  Container(
                      width: 60,
                      height: 60,
                      clipBehavior: Clip.none,
                      decoration: const BoxDecoration(),
                      child: Transform.scale(
                        scale: 2,
                        origin: const Offset(3, 6),
                        child: LottieBuilder.asset(
                          'assets/thinking.json',
                          height: 150,
                          width: 150,
                        ),
                      )),
                ],
              ),
              defaultSpace,
              PostField(userJoinModel: widget.userJoinedModel),
              defaultSpace,
              FriendSuggestionHorizontal(currentUser: userModel)
            ],
          ),
        ),
        Divider(
          height: 50,
          color: lightColor.withOpacity(0.2),
        ),
        BlocBuilder<GetPrayerRequestBloc, GetPrayerRequestState>(
          builder: (context, state) {
            if (state is LoadingPrayerRequesListSuccess) {
              if (state.prayerRequestPostModel.isEmpty) {
                return Center(
                    child: SizedBox(
                  height: MediaQuery.of(context).size.height - 250,
                  child: EndOfPostWidget(
                    isEmpty: true,
                    user: widget.userJoinedModel,
                  ),
                ));
              }

              return ListView(
                padding: const EdgeInsets.only(bottom: 120),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  const PostStatusWidget(),
                  ...state.prayerRequestPostModel.map((e) => PostItem(
                        postModel: e,
                        user: userModel,
                        fullView: false,
                      )),
                  defaultSpace,
                  EndOfPostWidget(
                    isEmpty: false,
                    user: widget.userJoinedModel,
                  ),
                ],
              );
            } else if (state is LoadingPrayerRequesList) {
              return const PostShimmerLoading();
            } else if (state is NoInternetConnnection) {
              return const Text('No Internet Connection');
            }
            return const PostShimmerLoading();
          },
        ),
      ],
    );
  }
}

class EndOfPostWidget extends StatelessWidget {
  const EndOfPostWidget({
    super.key,
    required this.isEmpty,
    required this.user,
  });
  final bool isEmpty;
  final UserJoinedModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Image(
          image: AssetImage('assets/angel.png'),
          width: 70,
          height: 70,
        ),
        defaultSpace,
        DefaultText(
            textAlign: TextAlign.center,
            text: isEmpty
                ? "No Prayer Intentions yet from\nyour friends."
                : "Keep spreading joy and positivity\nwherever you go!",
            color: secondaryColor),
        defaultSpace,
        Visibility(
          visible: isEmpty,
          child: BlocBuilder<PostPrayerRequestBloc, PostPrayerRequestState>(
            builder: (context, state) {
              if (state is PostPrayerRequestLoading) {
                return ElevatedButton.icon(
                    onPressed: () {
                      context.pushNamed('post_field', extra: user);
                    },
                    icon: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: whiteColor,
                        )),
                    label: const DefaultText(
                        text: 'Posting your prayer request..',
                        color: whiteColor));
              }
              return ElevatedButton.icon(
                  onPressed: () {
                    context.pushNamed('post_field', extra: user);
                  },
                  icon: const Icon(CupertinoIcons.pencil_circle_fill,
                      color: whiteColor),
                  label: const DefaultText(
                      text: 'Write your first prayer intention',
                      color: whiteColor));
            },
          ),
        ),
        Visibility(
          visible: isEmpty,
          child: TextButton.icon(
              onPressed: () {
                context.pushNamed('friend_suggest', extra: user.userModel);
              },
              icon: const Icon(CupertinoIcons.person_add_solid),
              label: const DefaultText(
                  text: 'Find friends', color: secondaryColor)),
        ),
      ],
    );
  }
}
