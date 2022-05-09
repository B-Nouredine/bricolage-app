import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../enums.dart';
import '../../Chat_Screen/all_messages_screen.dart';
import '../Home.dart';
import '../MyPosts.dart';
import '../ProfileScreen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key , required this.selectedMenu}) : super(key: key);
  final MenuState selectedMenu;
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
    width: double.infinity,
    height: 55,
    child: SafeArea(
      top: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            color: MenuState.home == selectedMenu
                ? kColor
                : inActiveIconColor,
            onPressed: ()=>Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context)=>const Home()
                )) ,
          ),
          IconButton(
            icon: const Icon(Icons.wysiwyg),
            color: MenuState.myPosts == selectedMenu
                ? kColor
                : inActiveIconColor,
            onPressed: ()  =>Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context)=>const MyPosts()
                )) ,
          ),
          MenuState.home == selectedMenu?
          const SizedBox(width: 14.0)
          :const SizedBox(width:0),
          IconButton(
            icon: const Icon(Icons.mark_chat_unread_rounded),
            color: MenuState.message == selectedMenu
                ? kColor
                : inActiveIconColor,
            onPressed: () =>Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context)=> AllMessages()
                )) ,
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            color: MenuState.profile == selectedMenu
                ? kColor
                : inActiveIconColor,
            onPressed: ()=>Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context)=>const ProfileScreen()
                )) ,
          ),
        ],
      ),
    ),
      );
  }
}
