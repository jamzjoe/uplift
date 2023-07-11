import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_item.dart';
import 'package:uplift/utils/widgets/button.dart';

import '../../../data/model/user_approved_mutual.dart';
import '../friend_suggestion/contacts.dart';

class FriendListView extends StatefulWidget {
  const FriendListView({
    Key? key,
    required this.approvedFriendList,
    required this.currentUser,
  }) : super(key: key);

  final UserModel currentUser;
  final List<UserApprovedMutualFriends> approvedFriendList;

  @override
  _FriendListViewState createState() => _FriendListViewState();
}

class _FriendListViewState extends State<FriendListView> {
  List<UserApprovedMutualFriends> filteredFriends = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    filteredFriends = widget.approvedFriendList;
    super.initState();
  }

  void _search(String query) {
    setState(() {
      filteredFriends = widget.approvedFriendList.where((user) {
        final displayName = user.userFriendshipModel.userModel.displayName;
        final emailAddress = user.userFriendshipModel.userModel.emailAddress;
        final phoneNumber = user.userFriendshipModel.userModel.phoneNumber;

        return (displayName != null &&
                displayName.toLowerCase().contains(query.toLowerCase())) ||
            (emailAddress != null &&
                emailAddress.toLowerCase().contains(query.toLowerCase())) ||
            (phoneNumber != null && phoneNumber.contains(query));
      }).toList();
    });
  }

  void updateUsers(List<UserApprovedMutualFriends> updatedUsers) {
    setState(() {
      filteredFriends = updatedUsers;
    });
  }

  Future<void> _importContacts() async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const Contacts();
    }));

    if (result != null) {
      _search(result);
      _searchController.text = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApprovedFriendsBloc, ApprovedFriendsState>(
      listener: (context, state) {
        log(state.toString());
        if (state is ApprovedFriendsSuccess2) {
          updateUsers(state.approvedFriendList);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomContainer(
                color: Colors.grey.shade100,
                widget: TextField(
                  controller: _searchController,
                  onChanged: _search,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    suffixIcon: IconButton(
                      onPressed: _importContacts,
                      icon: const Icon(Icons.contact_mail,
                          size: 18, color: primaryColor),
                    ),
                  ),
                ),
              ),
              filteredFriends.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<ApprovedFriendsBloc>(context).add(
                            RefreshApprovedFriend(widget.currentUser.userId!));
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final userFriendship =
                              filteredFriends[index].userFriendshipModel;
                          return FriendsItem(
                            mutualFriends: filteredFriends[index].mutualFriends,
                            userFriendship: userFriendship,
                            currentUser: widget.currentUser,
                            users: filteredFriends,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: .5,
                            color: secondaryColor.withOpacity(0.2),
                          );
                        },
                        itemCount: filteredFriends.length,
                      ),
                    )
                  : const Expanded(
                      child: Center(
                        child: Text('No user found'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
