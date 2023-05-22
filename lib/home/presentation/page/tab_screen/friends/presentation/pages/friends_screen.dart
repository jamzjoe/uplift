import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';
import 'friend_request/friend_request_list.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key, required this.currentUser});
  final UserModel currentUser;

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

String isSelected = 'Suggestions';

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: const HeaderText(text: 'Friends', color: secondaryColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Row(
            children: [
              CustomContainer(
                  onTap: () => context.pushNamed('friend_suggest',
                      extra: widget.currentUser),
                  widget: const DefaultText(
                      text: 'Suggestions', color: secondaryColor),
                  color: lightColor.withOpacity(0.3)),
              const SizedBox(width: 15),
              CustomContainer(
                  onTap: () {
                    context.pushNamed("friends-list",
                        extra: widget.currentUser);
                    BlocProvider.of<ApprovedFriendsBloc>(context).add(
                        FetchApprovedFriendRequest(widget.currentUser.userId!));
                  },
                  widget: const DefaultText(
                      text: 'Your Friends', color: secondaryColor),
                  color: lightColor.withOpacity(0.3))
            ],
          ),
          defaultSpace,
          const Divider(),
          defaultSpace,
          KeepAlivePage(
            child: FriendRequestList(
              currentUser: widget.currentUser,
            ),
          )
        ],
      ),
    );
  }
}
