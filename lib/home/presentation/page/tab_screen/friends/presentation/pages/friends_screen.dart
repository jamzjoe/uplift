import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';
import 'friend_request/friend_request_list.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key, required this.currentUser}) : super(key: key);
  final UserModel currentUser;

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

String isSelected = 'Suggestions';

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      closeOnBackButton: true,
      child: Scaffold(
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
                            // Navigate to 'friend_suggest' route
                            onTap: () {
                              context.pushNamed('friend_suggest',
                                  extra: widget.currentUser);
                            },
                            widget: DefaultText(
                                text: 'Suggestions', color: lighter),
                            color: whiteColor,
                          ),
                          const SizedBox(width: 15),
                          CustomContainer(
                            // Navigate to 'friends-list' route
                            onTap: () {
                              context.pushNamed("friends-list",
                                  extra: widget.currentUser);
                            },
                            widget: DefaultText(
                                text: 'Your Friends', color: lighter),
                            color: whiteColor,
                          ),
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
                      mainFriendScreenContext: context,
                      currentUser: widget.currentUser,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
