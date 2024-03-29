import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

import '../../../../../../../../constant/constant.dart';
import 'friend_request_header.dart';
import 'friend_request_item.dart';

class FriendRequestList extends StatefulWidget {
  const FriendRequestList({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  State<FriendRequestList> createState() => _FriendRequestListState();
}

class _FriendRequestListState extends State<FriendRequestList> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FriendRequestListView(
      currentUser: widget.currentUser,
    );
  }
}

class FriendRequestListView extends StatelessWidget {
  const FriendRequestListView({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendRequestBloc, FriendRequestState>(
      builder: (context, state) {
        log(state.toString());
        if (state is FriendRequestLoadingSuccess) {
          if (state.users.isEmpty) {
            return NoFriendRequest(currentUser: currentUser);
          }
          return ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              FriendRequestHeader(
                friendRequestCount: state.users.length,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return FriendRequestItem(
                    user: state.users[index].userFriendshipModel,
                    currentUser: currentUser,
                    mutualFriends: state.users[index].mutualFriends,
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: .5,
                    color: secondaryColor.withOpacity(0.2),
                  );
                },
                itemCount: state.users.length,
              ),
            ],
          );
        }
        return NoFriendRequest(currentUser: currentUser);
      },
    );
  }
}

class NoFriendRequest extends StatelessWidget {
  const NoFriendRequest({
    super.key,
    required this.currentUser,
  });

  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FriendRequestHeader(
          friendRequestCount: 0,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () =>
                context.pushNamed('friend_suggest', extra: currentUser),
            child: Container(
              alignment: Alignment.center,
              child: const NoDataMessage(text: 'No friend request yet'),
            ),
          ),
        ),
      ],
    );
  }
}
