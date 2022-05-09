import 'package:flutter/material.dart';
import 'src/settings_section.dart';
import 'src/settings_tile.dart';
import 'src/settings_list.dart';

class LanguagesScreen extends StatefulWidget {
  final int index;
  const LanguagesScreen({Key? key , required this.index}) : super(key: key);

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  late int languageIndex=widget.index;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          titleSpacing: 2,
          title: Text('Languages'),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(tiles: [
              SettingsTile(
                title: "French",
                trailing: trailingWidget(0),
                onPressed: (BuildContext context) {
                  changeLanguage(0);
                },
              ),
              SettingsTile(
                title: "English",
                trailing: trailingWidget(1),
                onPressed: (BuildContext context) {
                  changeLanguage(1);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? const Icon(Icons.check, color: Colors.blue)
        : const Icon(null);
  }

  void changeLanguage(int index) {
    setState(() {
      languageIndex = index;
    });
  }
  Future<bool> _onBackPressed() async {
    Navigator.pop(context,languageIndex);
     return true;
  }
}
