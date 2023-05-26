import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_field.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_shimmer_loading.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestion_horizontal.dart';
import 'package:uplift/utils/widgets/capitalize.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../feed_screen.dart';
import '../bloc/post_prayer_request/post_prayer_request_bloc.dart';
import 'post_item.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({
    Key? key,
    required this.userJoinedModel,
  }) : super(key: key);

  final UserJoinedModel userJoinedModel;

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = userJoinedModel.userModel;
    final User user = userJoinedModel.user;

    return Column(
      children: [
        Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const HeaderText(
                                  text: 'Hello ', color: darkColor),
                              HeaderText(
                                text: capitalizeFirstLetter(
                                    '${userModel.displayName},'),
                                color: secondaryColor,
                              ),
                            ],
                          ),
                          SmallText(
                            text: 'What would you like us to pray for?',
                            color: darkColor.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                    // const Image(
                    //     image: AssetImage('assets/prayer.png'), width: 50)
                    // Container(
                    //   width: 60,
                    //   height: 60,
                    //   clipBehavior: Clip.none,
                    //   child: Transform.scale(
                    //     scale: 2,
                    //     origin: const Offset(3, 6),
                    //     child: LottieBuilder.asset(
                    //       'assets/thinking.json',
                    //       height: 150,
                    //       width: 150,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 5),
                PostField(userJoinModel: userJoinedModel),
                const SizedBox(height: 5),
                FriendSuggestionHorizontal(currentUser: userModel),
              ],
            ),
          ),
        ),
        const SizedBox(height: 2.5),
        BlocBuilder<GetPrayerRequestBloc, GetPrayerRequestState>(
          builder: (context, state) {
            if (state is LoadingPrayerRequesListSuccess) {
              if (state.prayerRequestPostModel.isEmpty) {
                return Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 450,
                    child: EndOfPostWidget(
                      isEmpty: true,
                      user: userJoinedModel,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 120),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.prayerRequestPostModel.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const PostStatusWidget();
                  } else if (index <= state.prayerRequestPostModel.length) {
                    final e = state.prayerRequestPostModel[index - 1];
                    return PostItem(
                      postModel: e,
                      user: userModel,
                      fullView: false,
                    );
                  } else {
                    return EndOfPostWidget(
                      isEmpty: false,
                      user: userJoinedModel,
                    );
                  }
                },
              );
            } else if (state is LoadingPrayerRequesList ||
                state is NoInternetConnnection) {
              return const PostShimmerLoading();
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
            icon: const Icon(CupertinoIcons.person_add_solid),
            label:
                const DefaultText(text: 'Find friends', color: secondaryColor),
          ),
        ),
      ],
    );
  }
}
