import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../features/profile/profile_screen.dart';
import '../setting_screen.dart';

class MenuItems extends StatelessWidget {
  const MenuItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.white),
        onPressed: () async {
          final RenderBox appBarBox =
          context.findRenderObject() as RenderBox;
          final offset = appBarBox.localToGlobal(Offset.zero);
          await showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              offset.dx + appBarBox.size.width - 50,
              offset.dy + appBarBox.size.height,
              0,
              0,
            ),
            items: [
              PopupMenuItem(
                value: 'Profile',
                child: SizedBox(
                  width: 90,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Profile', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'Settings',
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.settings, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Settings', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
            color: Color(0xFF1B202D),
            elevation: 10,
          ).then((value) {
            if (value == 'Profile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileScreen()),
              );
            } else if (value == 'Settings') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()),
              );
            }
          });
        },
      ),
    );
  }
}