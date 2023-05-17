import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/search_bar.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

import 'add_friend_item.dart';

class FriendSuggestionList extends StatefulWidget {
  const FriendSuggestionList({
    super.key,
    required this.users,
    required this.currentUser,
  });
  final List<UserModel> users;
  final UserModel currentUser;

  @override
  State<FriendSuggestionList> createState() => _FriendSuggestionListState();
}

final TextEditingController searchController = TextEditingController();

class _FriendSuggestionListState extends State<FriendSuggestionList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        CustomSearchBar(
          hint: 'Search uplift user...',
          controller: searchController,
          onFieldSubmitted: (query) {
            BlocProvider.of<FriendsSuggestionsBlocBloc>(context)
                .add(SearchFriendSuggestions(query));
          },
        ),
        Visibility(
            visible: widget.users.isEmpty,
            child: const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: NoDataMessage(text: 'No user found in UpLift')))),
        ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return AddFriendItem(
                  user: widget.users[index], currentUser: widget.currentUser);
            },
            separatorBuilder: (context, index) {
              return Divider(
                  thickness: .5, color: secondaryColor.withOpacity(0.2));
            },
            itemCount: widget.users.length),
      ],
    );
  }
}
