import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/presentation/bloc/explore_get_prayer_request/explore_get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class TabBarMaterialWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;
  final TabController? controller;
  final UserModel user;

  const TabBarMaterialWidget({
    required this.index,
    required this.onChangedTab,
    super.key,
    this.controller,
    required this.user,
  });

  @override
  _TabBarMaterialWidgetState createState() => _TabBarMaterialWidgetState();
}

class _TabBarMaterialWidgetState extends State<TabBarMaterialWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: whiteColor,
      surfaceTintColor: whiteColor,
      padding: EdgeInsets.zero,
      shape: const CircularNotchedRectangle(),
      child: Container(
        color: whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildTabItem(
                label: 'Feed',
                index: 0,
                icon: const Icon(Ionicons.grid_outline, size: 23),
                selectedIcon: const Icon(Ionicons.grid, size: 23),
                userID: widget.user.userId!),
            buildTabItem(
                label: 'Friends',
                index: 1,
                icon:
                    const Icon(CupertinoIcons.person_2_square_stack, size: 23),
                selectedIcon: const Icon(
                    CupertinoIcons.person_2_square_stack_fill,
                    size: 23),
                userID: widget.user.userId!),
            GestureDetector(
              onTap: () => context.pushNamed('qr_reader', extra: widget.user),
              child: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.9),
                radius: 23,
                child: const Icon(
                  CupertinoIcons.qrcode,
                  color: whiteColor,
                ),
              ),
            ),
            buildTabItem(
                label: 'Explore',
                index: 2,
                icon: const Icon(CupertinoIcons.compass, size: 23),
                selectedIcon: const Icon(CupertinoIcons.compass_fill, size: 23),
                userID: widget.user.userId!),
            buildTabItem(
                label: 'Settings',
                index: 3,
                icon: const Icon(Ionicons.settings_outline, size: 23),
                selectedIcon: const Icon(Ionicons.settings, size: 23),
                userID: widget.user.userId!),
          ],
        ),
      ),
    );
  }

  Widget buildTabItem({
    required int index,
    required Icon icon,
    required Icon selectedIcon,
    required String label,
    required String userID,
  }) {
    final isSelected = index == widget.index;
    final color = isSelected ? primaryColor : lighter.withOpacity(0.5);

    if (index == 2) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            color: color,
            onPressed: () async {
              BlocProvider.of<ExploreBloc>(context)
                  .add(GetExplorePrayerRequestList(userID));
              widget.onChangedTab(index);
              widget.controller!.animateTo(index);
            },
            icon: isSelected ? selectedIcon : icon,
          ),
          SmallText(text: label, color: color),
        ],
      );
    }

    final friendRequestBloc = BlocProvider.of<FriendRequestBloc>(context);
    return BlocBuilder<FriendRequestBloc, FriendRequestState>(
      bloc: friendRequestBloc,
      builder: (context, state) {
        final int count =
            state is FriendRequestLoadingSuccess ? state.users.length : 0;
        if (index == 1) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Badge.count(
                isLabelVisible: count != 0,
                count: count,
                child: IconButton(
                  color: color,
                  onPressed: () async {
                    widget.onChangedTab(index);
                    widget.controller!.animateTo(index);
                  },
                  icon: isSelected ? selectedIcon : icon,
                ),
              ),
              SmallText(text: label, color: color),
            ],
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              color: color,
              onPressed: () async {
                widget.onChangedTab(index);
                widget.controller!.animateTo(index);
              },
              icon: isSelected ? selectedIcon : icon,
            ),
            SmallText(text: label, color: color),
          ],
        );
      },
    );
  }
}
