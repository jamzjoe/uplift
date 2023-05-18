import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

class FriendsFeed extends StatefulWidget {
  const FriendsFeed({super.key, required this.userModel});
  final UserModel userModel;

  @override
  State<FriendsFeed> createState() => _FriendsFeedState();
}

class _FriendsFeedState extends State<FriendsFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'Friends Feed', color: secondaryColor),
      ),
      body: BlocBuilder<ApprovedFriendsBloc, ApprovedFriendsState>(
        builder: (context, state) {
          if (state is ApprovedFriendsSuccess2) {
            return Column(
              children: [
                ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...state.approvedFriendList.map((e) => SizedBox(
                          child: ProfilePhoto(
                            user: e.userModel,
                            radius: 360,
                            size: 50,
                          ),
                        ))
                  ],
                ),
                Container()
              ],
            );
          }
          return ListView(
            children: const [],
          );
        },
      ),
    );
  }
}
