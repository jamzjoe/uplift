import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';

class SettingsItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  const SettingsItem({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      trailing: Icon(CupertinoIcons.chevron_forward,
          color: darkColor.withOpacity(0.6)),
      title: DefaultText(text: label, color: darkColor),
      leading: Icon(
        icon,
        color: darkColor.withOpacity(0.4),
      ),
    );
  }
}
