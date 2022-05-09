import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bricolage_app/screens/Home/Home.dart';
import 'package:bricolage_app/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:bricolage_app/components/custom_surfix_icon.dart';
import 'package:bricolage_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'src/settings_section.dart';
import 'src/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int languageIndex = 0;
  bool notificationsEnabled = true;
  String _value = 'ThemeMode.system';
  bool state = false;
  late final SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getState(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            /* SettingsSection(
              title: 'Common',
              tiles: [
                SettingsTile(
                  title: 'Language',
                  subtitle: klanguages[languageIndex],
                  leading: const Icon(Icons.language),
                  onPressed: (context) async {
                    final result=await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LanguagesScreen(index: languageIndex)
                    ));
                    setState(() {
                      languageIndex=result;
                    });
                  },
                ),
              ],
            ),*/
            const SizedBox(height: 15.0),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                '    Appearance',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              ListTile(
                title: const Text('System default'),
                trailing: Radio(
                  value: 'ThemeMode.system',
                  groupValue: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = value.toString();
                      MyApp.themeNotifier.value = ThemeMode.system;
                      prefs.setString('ThemeMode', ThemeMode.system.toString());
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Dark Mode'),
                trailing: Radio(
                  value: 'ThemeMode.dark',
                  groupValue: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = value.toString();
                      MyApp.themeNotifier.value = ThemeMode.dark;
                      prefs.setString('ThemeMode', ThemeMode.dark.toString());
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Light Mode'),
                trailing: Radio(
                  value: 'ThemeMode.light',
                  groupValue: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = value.toString();
                      MyApp.themeNotifier.value = ThemeMode.light;
                      prefs.setString('ThemeMode', ThemeMode.light.toString());
                    });
                  },
                ),
              ),
            ]),
            const SizedBox(height: 15.0),
            SettingsSection(
              title: 'Security',
              tiles: [
                SettingsTile(
                  title: 'Change password',
                  leading: const Icon(Icons.lock),
                  onPressed: (context) {
                    changePassword();
                  },
                ),
                SettingsTile.switchTile(
                  title: 'Use fingerprint',
                  subtitle:
                      'Allow application to access stored fingerprint IDs.',
                  leading: const Icon(Icons.fingerprint),
                  switchValue: state,
                  enabled: true,
                  onToggle: (bool value) {
                    setState(() {
                      try {
                        state = !state;
                        firestore
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .update({
                          'fingerPrintEnabled': state,
                        });
                      } catch (e) {
                        showToast(txt: "Cannot use this feature now");
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getState(BuildContext context) async {
    List data = [];
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _value=MyApp.themeNotifier.value.toString();
    });

    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((querysnapshot) {
      {
        data.add(querysnapshot.data());
      }
    });
    setState(() {
      state = data[0]['fingerPrintEnabled'];
    });
  }

  void changePassword() {
    String newPassword = "", oldPassword = "";
    final _formKey = GlobalKey<FormState>();
    showDialog(
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Password"),
            content: Form(
              key: _formKey,
              child: Wrap(runSpacing: 25.0, children: [
                Divider(
                  color: kColor,
                ),
                Container(
                  alignment: Alignment.center,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter old password';
                      }
                      return null;
                    },
                    obscureText: true,
                    onSaved: (newValue) => oldPassword = newValue!,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      labelText: "Old Password",
                      hintText: "Enter your Old password",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon:
                          CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new password';
                      }
                      return null;
                    },
                    obscureText: true,
                    onSaved: (newValue) => newPassword = newValue!,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      labelText: "New Password",
                      hintText: "Enter your New password",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon:
                          CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(kColor)),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 23),
                        child: Text("Save", style: TextStyle(fontSize: 18)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _changePassword(oldPassword, newPassword);
                        }
                      }),
                ),
                SizedBox(
                  height: 20,
                )
              ]),
            ),
          );
        });
  }

  void _changePassword(String currentPassword, String newPassword) {
    final user = auth.currentUser;
    final email = user?.email ?? "";
    bool password = true;
    final cred =
        EmailAuthProvider.credential(email: email, password: currentPassword);

    user?.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {}).catchError((error) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("Connection Error",
                    style: TextStyle(fontSize: 25, color: Colors.red)),
                actions: [
                  TextButton(
                    child: Text("OK", style: TextStyle(color: Colors.green)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        password = false;
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("Password Incorrect",
                  style: TextStyle(fontSize: 25, color: Colors.red)),
              actions: [
                TextButton(
                  child:
                      Text("OK", style: const TextStyle(color: Colors.green)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      password = false;
    });
    Navigator.of(context).pop();
    if (password == true) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("Password Changed",
                  style: TextStyle(fontSize: 25, color: Colors.green)),
              actions: [
                TextButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(color: kColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}
