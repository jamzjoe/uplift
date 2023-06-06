import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_tab_view.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestion_horizontal.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

import '../bloc/get_prayer_request/get_prayer_request_bloc.dart';

class TabListView extends StatelessWidget {
  const TabListView({
    Key? key,
    required this.widget,
    required this.filteredPosts,
  }) : super(key: key);

  final List<PostModel> filteredPosts;
  final PostTabView widget;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
       onRefresh: () async {
// Handle refresh action
              BlocProvider.of<GetPrayerRequestBloc>(context)
                  .add(RefreshPostRequestList(widget.userModel.userId!));
            },
      child: ListView(
        children: [
          Column(
            children: [
              FriendSuggestionHorizontal(
                currentUser: widget.userModel,
                userJoinedModel: widget.widget.userJoinedModel,
              ),
            ],
          ),
          if (filteredPosts.isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: const Center(
                child: NoDataMessage(text: 'No prayer intention found.'),
              ),
            ),
          ListView.builder(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredPosts.length + 1,
            itemBuilder: (context, index) {
              if (index < filteredPosts.length) {
                final e = filteredPosts[index];
                return PostItem(
                  allPost: filteredPosts,
                  postModel: e,
                  user: widget.userModel,
                  fullView: false,
                );
              }
              return null;
            },
          ),
          defaultSpace,
          if (filteredPosts.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DefaultText(
                  textAlign: TextAlign.center,
                  text:
                      "You've covered all the prayer intentions.\nContinue seeking inspiration and upliftment.",
                  color: lighter.withOpacity(0.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
