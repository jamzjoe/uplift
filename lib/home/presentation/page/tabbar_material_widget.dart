import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class TabBarMaterialWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;
  final TabController? controller;

  const TabBarMaterialWidget({
    required this.index,
    required this.onChangedTab,
    super.key,
    this.controller,
  });

  @override
  _TabBarMaterialWidgetState createState() => _TabBarMaterialWidgetState();
}

class _TabBarMaterialWidgetState extends State<TabBarMaterialWidget> {
  @override
  Widget build(BuildContext context) {
    const placeholder = Opacity(
      opacity: 0,
      child: IconButton(icon: Icon(Icons.no_cell), onPressed: null),
    );

    return BottomAppBar(
      color: whiteColor,
      elevation: 10,
      surfaceTintColor: whiteColor,
      padding: const EdgeInsets.symmetric(vertical: 5),
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      clipBehavior: Clip.antiAlias,
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
            ),
            buildTabItem(
              label: 'Friends',
              index: 1,
              icon: const Icon(CupertinoIcons.person_2_square_stack, size: 23),
              selectedIcon: const Icon(
                  CupertinoIcons.person_2_square_stack_fill,
                  size: 23),
            ),
            placeholder,
            buildTabItem(
                label: 'Explore',
                index: 2,
                icon: const Icon(CupertinoIcons.compass, size: 23),
                selectedIcon:
                    const Icon(CupertinoIcons.compass_fill, size: 23)),
            buildTabItem(
              label: 'Settings',
              index: 3,
              icon: const Icon(Ionicons.settings_outline, size: 23),
              selectedIcon: const Icon(Ionicons.settings, size: 23),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabItem(
      {required int index,
      required Icon icon,
      required Icon selectedIcon,
      required String label}) {
    final isSelected = index == widget.index;
    if (index == 1) {
      return BlocBuilder<FriendRequestBloc, FriendRequestState>(
        builder: (context, state) {
          if (state is FriendRequestLoadingSuccess) {
            int count = state.users.length;
            return Badge.count(
              isLabelVisible: count != 0,
              count: count,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      color: isSelected
                          ? secondaryColor
                          : secondaryColor.withOpacity(0.5),
                      onPressed: () async {
                        widget.onChangedTab(index);
                        widget.controller!.animateTo(index);
                      },
                      icon: isSelected ? selectedIcon : icon),
                  SmallText(
                      text: label,
                      color: isSelected
                          ? secondaryColor
                          : secondaryColor.withOpacity(0.5))
                ],
              ),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  color: isSelected
                      ? secondaryColor
                      : secondaryColor.withOpacity(0.5),
                  onPressed: () async {
                    widget.onChangedTab(index);
                    widget.controller!.animateTo(index);
                  },
                  icon: isSelected ? selectedIcon : icon),
              SmallText(
                  text: label,
                  color: isSelected
                      ? secondaryColor
                      : secondaryColor.withOpacity(0.5))
            ],
          );
        },
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            color:
                isSelected ? secondaryColor : secondaryColor.withOpacity(0.5),
            onPressed: () async {
              widget.onChangedTab(index);
              widget.controller!.animateTo(index);
            },
            icon: isSelected ? selectedIcon : icon),
        SmallText(
            text: label,
            color:
                isSelected ? secondaryColor : secondaryColor.withOpacity(0.5))
      ],
    );
  }
}
