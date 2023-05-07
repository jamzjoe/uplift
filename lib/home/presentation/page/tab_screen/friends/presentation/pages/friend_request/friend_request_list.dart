import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

import 'friend_request_header.dart';
import 'friend_request_item.dart';

class FriendRequestList extends StatefulWidget {
  const FriendRequestList({
    super.key,
    required this.currentUser,
  });
  final User currentUser;

  @override
  State<FriendRequestList> createState() => _FriendRequestListState();
}

class _FriendRequestListState extends State<FriendRequestList> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: const [
        FriendRequestListView(),
      ],
    );
  }
}

class FriendRequestListView extends StatelessWidget {
  const FriendRequestListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendRequestBloc, FriendRequestState>(
      builder: (context, state) {
        if (state is FriendRequestLoadingSuccess) {
          if (state.users.isEmpty) {
            return Column(
              children: [
                FriendRequestHeader(
                  friendRequestCount: state.users.length,
                ),
                const NoDataMessage(text: 'No friend request yet'),
                const SizedBox()
              ],
            );
          }
          return ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              FriendRequestHeader(
                friendRequestCount: state.users.length,
              ),
              ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  return FriendRequestItem(user: state.users[index]);
                },
              ),
            ],
          );
        }
        return const Text(
          'Error',
        );
      },
    );
  }
}
