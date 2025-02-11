import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../model/menu_items.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 25,
      toolbarHeight: 50,
      backgroundColor: DefaultColors.messageListPage,
      title: const Text("Chats", style: TextStyle(color: Colors.white)),
      actions: [
        SizedBox(
          width: 50,
          child: IconButton(
            icon: const Icon(Icons.qr_code_scanner_sharp, color: Colors.white),
            onPressed: () {},
          ),
        ),
        SizedBox(
          width: 28,
          child: IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 10),
        MenuItems(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}