import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/friend_request_list.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/friends_list.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

String isSelected = 'Friend Request';

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'Friends', color: secondaryColor),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  CustomContainer(
                      onTap: () => setState(() {
                            isSelected = 'Friend Request';
                          }),
                      widget: const DefaultText(
                          text: 'Friend request', color: secondaryColor),
                      color: isSelected == 'Friend Request'
                          ? primaryColor.withOpacity(0.2)
                          : lightColor.withOpacity(0.3)),
                  const SizedBox(width: 15),
                  CustomContainer(
                      onTap: () => setState(() {
                            isSelected = 'Your Friends';
                          }),
                      widget: const DefaultText(
                          text: 'Your Friends', color: secondaryColor),
                      color: isSelected == 'Your Friends'
                          ? primaryColor.withOpacity(0.2)
                          : lightColor.withOpacity(0.3)),
                ],
              ),
              defaultSpace,
              const Divider(),
              defaultSpace,
              isSelected == 'Friend Request'
                  ? const FriendRequestList()
                  : const FriendsList()
            ],
          ),
        ),
      ),
    );
  }
}
