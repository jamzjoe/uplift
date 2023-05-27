import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_item.dart';
import 'package:uplift/utils/widgets/header_text.dart';

import '../../../data/model/user_approved_mutual.dart';
import '../friend_suggestion/contacts.dart';

class FriendListView extends StatefulWidget {
  const FriendListView({
    super.key,
    required this.approvedFriendList,
    required this.currentUser,
  });

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _search,
            decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: TextButton.icon(
                    label: const HeaderText(
                        text: 'IMPORT', color: secondaryColor, size: 12),
                    onPressed: () async {
                      final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const Contacts();
                      }));

                      _search(result);
                      setState(() {
                        _searchController.text = result;
                      });
                    },
                    icon: const Icon(Icons.contact_mail, size: 18))),
          ),
          Expanded(
            child: filteredFriends.isNotEmpty
                ? ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return FriendsItem(
                        mutualFriends: filteredFriends[index].mutualFriends,
                        userFriendship:
                            filteredFriends[index].userFriendshipModel,
                        currentUser: widget.currentUser,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        thickness: .5,
                        color: secondaryColor.withOpacity(0.2),
                      );
                    },
                    itemCount: filteredFriends.length,
                  )
                : const Center(
                    child: Text('No user found'),
                  ),
          ),
        ],
      ),
    );
  }
}
