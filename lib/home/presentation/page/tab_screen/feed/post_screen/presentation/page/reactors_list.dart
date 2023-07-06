import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/widget/check_friend_status.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../../../../../../authentication/data/model/user_model.dart';

class ReactorsList extends StatefulWidget {
  const ReactorsList(
      {super.key, required this.userID, required this.currentUser});
  final List<dynamic> userID;
  final UserModel currentUser;

  @override
  State<ReactorsList> createState() => _ReactorsListState();
}

class _ReactorsListState extends State<ReactorsList> {
  List<UserModel> users = [];
  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'People who prayed', color: darkColor),
      ),
      body: SafeArea(
        child: ListView(
          itemExtent: 50,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          shrinkWrap: true,
          children: [
            ...users.map((e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ProfilePhoto(user: e),
                        const SizedBox(width: 10),
                        SmallText(text: e.displayName!, color: darkColor),
                      ],
                    ),
                    CheckFriendsStatusWidget(
                        user: e, currentUser: widget.currentUser)
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void fetchUsers() async {
    final List<UserModel?> userModels = await Future.wait<UserModel?>(
        widget.userID.map((e) => PrayerRequestRepository().getUserRecord(e)));

    setState(() {
      users = userModels.whereType<UserModel>().toList();
    });
  }
}
