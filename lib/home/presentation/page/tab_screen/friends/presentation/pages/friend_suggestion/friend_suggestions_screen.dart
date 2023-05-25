import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/contacts.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestion_list.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_item_shimmer.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/search_bar.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

class FriendSuggestions extends StatefulWidget {
  const FriendSuggestions({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  State<FriendSuggestions> createState() => _FriendSuggestionsState();
}

final TextEditingController searchController = TextEditingController();
String contact = '';

class _FriendSuggestionsState extends State<FriendSuggestions> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        searchController.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton.icon(
                label: const HeaderText(
                    text: 'IMPORT', color: secondaryColor, size: 12),
                onPressed: () async {
                  final result = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return const Contacts();
                  }));

                  setState(() {
                    contact = result;
                    searchController.text = result;
                    search(context, result);
                  });
                },
                icon: const Icon(CupertinoIcons.add_circled_solid)),
          ],
          title: const HeaderText(
            text: 'Friend suggestions',
            color: darkColor,
            size: 18,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            children: [
              CustomSearchBar(
                hint: 'Search uplift user...',
                controller: searchController,
                onFieldSubmitted: (query) {
                  search(context, query);
                },
              ),
              BlocBuilder<FriendsSuggestionsBlocBloc,
                  FriendsSuggestionsBlocState>(
                builder: (context, state) {
                  if (state is FriendsSuggestionLoading) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return const FriendsShimmerItem();
                      },
                    );
                  } else if (state is FriendsSuggestionLoadingSuccess) {
                    if (state.users.isEmpty) {
                      return Column(
                        children: const [
                          Center(
                            child: NoDataMessage(text: 'No user found'),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        FriendSuggestionList(
                          users: state.users,
                          currentUser: widget.currentUser,
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void search(BuildContext context, String query) {
    BlocProvider.of<FriendsSuggestionsBlocBloc>(context)
        .add(SearchFriendSuggestions(query));
  }
}
