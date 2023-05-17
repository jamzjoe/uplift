import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendRequestBloc, FriendRequestState>(
      builder: (context, state) {
        if (state is FriendRequestLoadingSuccess) {
          if (state.users.isEmpty) {
            return ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                FriendRequestHeader(
                  friendRequestCount: state.users.length,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: NoDataMessage(text: 'No friend request yet'),
                ),
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
              ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return FriendRequestItem(
                      user: state.users[index],
                      currentUser: currentUser,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                        thickness: .5, color: secondaryColor.withOpacity(0.2));
                  },
                  itemCount: state.users.length),
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
