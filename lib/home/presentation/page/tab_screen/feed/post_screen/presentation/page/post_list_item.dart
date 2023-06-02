import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_shimmer_loading.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_tab_view.dart';
import 'package:uplift/utils/services/ui_services.dart';
import 'package:uplift/utils/widgets/capitalize.dart';
import 'package:uplift/utils/widgets/date_widget.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../bloc/post_prayer_request/post_prayer_request_bloc.dart';

class PostListItem extends StatefulWidget {
  const PostListItem({
    Key? key,
    required this.userJoinedModel,
  }) : super(key: key);

  final UserJoinedModel userJoinedModel;

  @override
  State<PostListItem> createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  @override
  Widget build(BuildContext context) {
    final UserModel userModel = widget.userJoinedModel.userModel;
    return ListView(
      children: [
        Container(
          width: double.infinity,
          color: whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ProfilePhoto(user: userModel),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SmallText(
                                    text: 'Hello ', color: darkColor),
                                HeaderText(
                                  text:
                                      "${Tools().splitName(capitalizeFirstLetter('${userModel.displayName}'))},",
                                  color: secondaryColor,
                                  size: 20,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TextDateWidget(
                                  date: DateTime.now(),
                                  fillers: 'Today is',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    StreamBuilder<Map<String, dynamic>>(
                      stream: NotificationRepository()
                          .notificationListener(userModel.userId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final count = snapshot.data!['length'];
                          return Badge.count(
                            isLabelVisible: count != 0,
                            count: count,
                            alignment: AlignmentDirectional.bottomStart,
                            child: IconButton(
                              onPressed: () {
                                goToNotificationScreen(
                                    userModel.userId!, context, userModel);
                              },
                              icon: Icon(
                                Ionicons.notifications,
                                size: 28,
                                color: lighter,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2.5),
        BlocBuilder<GetPrayerRequestBloc, GetPrayerRequestState>(
          builder: (context, state) {
            if (state is LoadingPrayerRequesListSuccess) {
              final posts = state.prayerRequestPostModel;
              if (posts.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 250,
                  child: Center(
                    child: EndOfPostWidget(
                      isEmpty: true,
                      user: widget.userJoinedModel,
                    ),
                  ),
                );
              }
              return PostTabView(
                  posts: posts, userModel: userModel, widget: widget);
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

  void goToNotificationScreen(
      String userID, BuildContext context, UserModel userModel) {
    BlocProvider.of<NotificationBloc>(context).add(MarkAllAsRead(userID));
    context.pushNamed('notification', extra: userModel);
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
