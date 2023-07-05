import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_item.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_tab_view.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestion_horizontal.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

import '../bloc/get_prayer_request/get_prayer_request_bloc.dart';

class TabListView extends StatefulWidget {
  const TabListView({
    Key? key,
    required this.widget,
    required this.filteredPosts,
    required this.scrollController,
  }) : super(key: key);

  final List<PostModel> filteredPosts;
  final PostTabView widget;
  final ScrollController scrollController;

  @override
  State<TabListView> createState() => _TabListViewState();
}

class _TabListViewState extends State<TabListView> {
  int pageIndex = 10;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Handle refresh action
        BlocProvider.of<GetPrayerRequestBloc>(context).add(
          RefreshPostRequestList(widget.widget.userModel.userId!),
        );
      },
      child: ListView(
        controller: widget.scrollController,
        children: [
          Column(
            children: [
              FriendSuggestionHorizontal(
                currentUser: widget.widget.userModel,
                userJoinedModel: widget.widget.widget.userJoinedModel,
              ),
            ],
          ),
          if (widget.filteredPosts.isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: const Center(
                child: NoDataMessage(text: 'No prayer intention found.'),
              ),
            ),
          ListView.builder(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.filteredPosts.length + 1,
            itemBuilder: (context, index) {
              if (index < widget.filteredPosts.length) {
                final e = widget.filteredPosts[index];

                return PostItem(
                  allPost: widget.filteredPosts,
                  postModel: e,
                  user: widget.widget.userModel,
                  fullView: false,
                );
              }
              return null;
            },
          ),
          if (widget.filteredPosts.isNotEmpty)
            const SpinKitChasingDots(color: primaryColor),
        ],
      ),
    );
  }
}
