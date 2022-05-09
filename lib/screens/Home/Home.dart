import 'package:flutter/material.dart';
import 'package:bricolage_app/enums.dart';
import 'package:bricolage_app/screens/Home/components/Body.dart';
import 'package:bricolage_app/screens/Home/components/Bottom_Nav_Bar.dart';
import 'package:bricolage_app/screens/Home/Add_Post.dart';
import 'side_bar_menu.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBarMenu(),
      appBar: AppBar(
        // leading: IconButton(
        //   splashRadius: 25,
        //   onPressed: () {
        //     Scaffold.of(context).openDrawer();
        //   },
        //   icon: const Icon(Icons.legend_toggle),
        // ),
        actions: [
          IconButton(
            splashRadius: 25,
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 30.0)
        ],
        title: const Text("SJOB"),
        elevation: 0,
        centerTitle: true,
      ),
      body: const Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Add_Post())),
        child: const Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
