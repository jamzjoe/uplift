import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/contacts.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_list.dart';
import 'package:uplift/utils/widgets/header_text.dart';

import '../search_bar.dart';

class YourFriendsScreen extends StatefulWidget {
  const YourFriendsScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<YourFriendsScreen> createState() => _YourFriendsScreenState();
}

final searchController = TextEditingController();
String? contact;

class _YourFriendsScreenState extends State<YourFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        searchController.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const HeaderText(text: 'All friends', color: darkColor),
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
        ),
        body: RefreshIndicator(
          onRefresh: () async => BlocProvider.of<ApprovedFriendsBloc>(context)
              .add(FetchApprovedFriendRequest(widget.user.userId!)),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            children: [
              CustomSearchBar(
                controller: searchController,
                onFieldSubmitted: (query) {
                  search(context, query);
                },
                hint: 'Search your friend here...',
              ),
              FriendsList(currentUser: widget.user),
            ],
          ),
        ),
      ),
    );
  }

  void search(BuildContext context, String query) {
    BlocProvider.of<ApprovedFriendsBloc>(context)
        .add(SearchApprovedFriend(query));
  }
}
