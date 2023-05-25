import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';
import 'package:uplift/utils/widgets/post_item_shimmer.dart';

class PrayerIntentionPage extends StatefulWidget {
  const PrayerIntentionPage({
    super.key,
    required this.user,
    this.isSelf, required this.currentUser,
  });

  final UserModel user;
  final UserModel currentUser;
  final bool? isSelf;

  @override
  State<PrayerIntentionPage> createState() => _PrayerIntentionPageState();
}

final ScrollController scrollController = ScrollController();

class _PrayerIntentionPageState extends State<PrayerIntentionPage> {
  @override
  Widget build(BuildContext context) {
    return KeepAlivePage(
      child: FutureBuilder<List<PostModel>>(
        future: PrayerRequestRepository()
            .getPrayerIntentions(widget.user.userId!, widget.isSelf ?? false),
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
                    user: widget.currentUser,
                    fullView: false,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
