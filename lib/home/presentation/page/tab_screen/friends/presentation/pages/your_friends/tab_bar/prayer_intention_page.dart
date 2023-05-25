import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/tab_bar/friends_tab_bar.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';
import 'package:uplift/utils/widgets/post_item_shimmer.dart';

class PrayerIntentionPage extends StatefulWidget {
  const PrayerIntentionPage({
    super.key,
    required this.user,
    required this.widget,
  });

  final UserModel user;
  final FriendsTabBarView widget;

  @override
  State<PrayerIntentionPage> createState() => _PrayerIntentionPageState();
}

class _PrayerIntentionPageState extends State<PrayerIntentionPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostModel>>(
      future: PrayerRequestRepository().getPrayerIntentions(
          widget.user.userId!, widget.widget.isSelf ?? false),
      builder: (context, result) {
        final data = result.data;
        if (result.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const PostItemShimmerLoading();
            },
          );
        }
        if (!result.hasData || result.data!.isEmpty) {
          return const Center(
            child: NoDataMessage(text: 'No prayer intention found.'),
          );
        }
        return Container(
          color: Colors.grey.shade100,
          child: ListView(
            children: [
              ...data!.map(
                (e) => PostItem(
                  postModel: e,
                  user: e.userModel,
                  fullView: false,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
