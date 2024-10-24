import 'package:flutter/material.dart';

import 'package:lucide_icons/lucide_icons.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  // final VoidCallback refresher;
  const CustomAppBar({
    super.key,
    /*required this.refresher*/
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Specify the preferred size
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Secure Notes 🔒",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
          child: IconButton(
              iconSize: 22,
              onPressed: () async {},
              icon: const Icon(LucideIcons.copyPlus)),
        )
      ],
    );
  }
}
