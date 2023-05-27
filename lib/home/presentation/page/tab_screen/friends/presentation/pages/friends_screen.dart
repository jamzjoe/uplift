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
        title: const HeaderText(text: 'Friends', color: darkColor),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          height: MediaQuery.of(context).size.height - 150,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomContainer(
                            onTap: () {
                              context.pushNamed('friend_suggest',
                                  extra: widget.currentUser);
                            },
                            widget: DefaultText(
                                text: 'Suggestions', color: lighter),
                            color: lightColor.withOpacity(0.3)),
                        const SizedBox(width: 15),
                        CustomContainer(
                            onTap: () {
                              context.pushNamed("friends-list",
                                  extra: widget.currentUser);
                           
                            },
                            widget: DefaultText(
                                text: 'Your Friends', color: lighter),
                            color: lightColor.withOpacity(0.3))
                      ],
                    ),
                    defaultSpace,
                    const Divider(),
                    defaultSpace,
                  ],
                ),
              ),
              Expanded(
                child: KeepAlivePage(
                  child: FriendRequestList(
                    currentUser: widget.currentUser,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
