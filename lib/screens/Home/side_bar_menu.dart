import 'package:flutter/material.dart';
import 'ProfileScreen.dart';

class SideBarMenu extends StatelessWidget {
  const SideBarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: ProfileScreen(
        sidebarMenu: true,
      ),
    );
  }
}
