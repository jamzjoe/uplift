import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_list.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class YourFriendsScreen extends StatefulWidget {
  const YourFriendsScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<YourFriendsScreen> createState() => _YourFriendsScreenState();
}

class _YourFriendsScreenState extends State<YourFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'All friends', color: darkColor),
        actions: [
          TextButton(
              onPressed: () {
                BlocProvider.of<ApprovedFriendsBloc>(context)
                    .add(RefreshApprovedFriend(widget.user.userId!));
              },
              child: const SmallText(text: 'Refresh', color: linkColor)),
        ],
      ),
      body: FriendsList(currentUser: widget.user),
    );
  }
}
