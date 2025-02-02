import 'package:flutter/material.dart';

import '../../ui.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: LogoApp(
        textSize: 20,
        iconSize: 30,
      ),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Leonardo',
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              child: Icon(
                Icons.person,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
