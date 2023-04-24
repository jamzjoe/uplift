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
      padding: const EdgeInsets.symmetric(vertical: 5),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTabItem(
            index: 0,
            icon: const Icon(Ionicons.grid_outline),
          ),
          buildTabItem(
            index: 1,
            icon: const Icon(Ionicons.person_circle_outline, size: 30),
          ),
          placeholder,
          buildTabItem(
            index: 2,
            icon: const Icon(Ionicons.calendar_outline),
          ),
          buildTabItem(
            index: 3,
            icon: const Icon(Ionicons.settings_outline),
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({
    required int index,
    required Icon icon,
  }) {
    final isSelected = index == widget.index;

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? primaryColor : secondaryColor.withOpacity(0.5),
      ),
      child: IconButton(
        icon: icon,
        onPressed: () {
          widget.onChangedTab(index);
          widget.controller!.animateTo(index);
        },
      ),
    );
  }
}
