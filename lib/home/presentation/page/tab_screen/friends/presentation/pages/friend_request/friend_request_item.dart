import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_item.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

import '../../bloc/approved_friends_bloc/approved_friends_bloc.dart';

class FriendRequestItem extends StatefulWidget {
  const FriendRequestItem({
    Key? key,
    required this.user,
    required this.currentUser,
    required this.mutualFriends,
  }) : super(key: key);

  final UserFriendshipModel user;
  final UserModel currentUser;
  final List<UserFriendshipModel> mutualFriends;

  @override
  State<FriendRequestItem> createState() => _FriendRequestItemState();
}

class _FriendRequestItemState extends State<FriendRequestItem> {
  bool isAccepting = false;
  bool isIgnoring = false;

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = widget.user.userModel;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () =>
          CustomDialog().showProfile(context, widget.currentUser, userModel),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfilePhoto(user: userModel, radius: 15),
            const SizedBox(width: 15),
            Flexible(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: HeaderText(
                          text: userModel.displayName ?? 'User',
                          color: darkColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  MutualFriendWidget(mutualFriends: widget.mutualFriends),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              isIgnoring = true;
                            });
                            await FriendsRepository()
                                .ignore(widget.user.friendshipID.friendshipId!)
                                .then((value) {
                              setState(() {
                                isIgnoring = false;
                              });
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: lightColor.withOpacity(0.2),
                            ),
                            child: Center(
                              child: isIgnoring
                                  ? const TapLoading(color: darkColor)
                                  : DefaultText(text: 'Ignore', color: lighter),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: isAccepting
                              ? null
                              : () async {
                                  setState(() {
                                    isAccepting = true;
                                  });
                                  BlocProvider.of<FriendRequestBloc>(context)
                                      .add(FetchFriendRequestEvent(
                                          widget.currentUser.userId!));
                                  FriendsRepository()
                                      .acceptFriendshipRequest(
                                          userModel.userId!,
                                          widget.currentUser.userId!,
                                          widget.currentUser,
                                          userModel,
                                          context)
                                      .then((value) {
                                    setState(() {
                                      isAccepting = false;
                                    });
                                    BlocProvider.of<FriendsSuggestionsBlocBloc>(
                                            context)
                                        .add(FetchUsersEvent(
                                            widget.currentUser.userId!));
                                    BlocProvider.of<ApprovedFriendsBloc>(
                                            context)
                                        .add(FetchApprovedFriendRequest(
                                            widget.currentUser.userId!));
                                  });
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 15),
                            decoration: BoxDecoration(
                              color: linkColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: isAccepting
                                  ? const TapLoading(color: whiteColor)
                                  : const DefaultText(
                                      text: 'Confirm', color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TapLoading extends StatelessWidget {
  const TapLoading({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 1.5, color: color),
    );
  }
}
