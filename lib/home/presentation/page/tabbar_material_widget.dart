import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';

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
      elevation: 5,
      surfaceTintColor: whiteColor,
      padding: const EdgeInsets.symmetric(vertical: 5),
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTabItem(
            label: 'Feed',
            index: 0,
            icon: const Icon(Ionicons.grid_outline, size: 28),
            selectedIcon: const Icon(Ionicons.grid, size: 28),
          ),
          buildTabItem(
            label: 'Friends',
            index: 1,
            icon: const Icon(CupertinoIcons.person_2_square_stack, size: 28),
            selectedIcon:
                const Icon(CupertinoIcons.person_2_square_stack_fill, size: 28),
          ),
          placeholder,
          buildTabItem(
              label: 'Events',
              index: 2,
              icon: const Icon(Ionicons.calendar_outline, size: 28),
              selectedIcon: const Icon(Ionicons.calendar, size: 28)),
          buildTabItem(
            label: 'Settings',
            index: 3,
            icon: const Icon(Ionicons.settings_outline, size: 28),
            selectedIcon: const Icon(Ionicons.settings, size: 28),
          ),
        ],
      ),
    );
  }

  Widget buildTabItem(
      {required int index,
      required Icon icon,
      required Icon selectedIcon,
      required String label}) {
    final isSelected = index == widget.index;

    return IconButton(
        color: isSelected ? primaryColor : secondaryColor.withOpacity(0.5),
        onPressed: () {
          widget.onChangedTab(index);
          widget.controller!.animateTo(index);
        },
        icon: isSelected ? selectedIcon : icon);
  }
}
