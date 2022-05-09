import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

PreferredSizeWidget? standardAppBar() => AppBar(
      leading: const IconButton(
        // inserts a menu
        onPressed: null,
        tooltip: 'Navigation menu',
        icon: Icon(Icons.menu),
      ),
      actions: const [
        //! this creates a rate_us button
        // IconButton(
        //   icon: Icon(Icons.star),
        //   tooltip: 'Rate_us',
        //   onPressed: null,
        //   iconSize: 40,
        //   disabledColor: Colors.white70,
        //   hoverColor: Colors.red,
        //   visualDensity: VisualDensity(horizontal: 1, vertical: 0.1),
        // ),
      ],
      backgroundColor: Colors.blueGrey[900],
      title: const Center(child: Text('Bricolage App')),
      titleTextStyle: const TextStyle(
          color: Colors.white54,
          fontSize: 24,
          // fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          letterSpacing: 0.05),
    );

InputDecoration textFieldDecoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white30),
      // enabledBorder:
      //     UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          gapPadding: 4,
          borderSide: BorderSide(color: Colors.white)),

      // focusedBorder:
      //     UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)));
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          gapPadding: 4,
          borderSide: BorderSide(color: Colors.blueAccent)),
    );

TextStyle simpleTextStyle(
        {double width = 12,
        bool underlined = false,
        bool bold = false,
        Color color = Colors.white}) =>
    TextStyle(
        color: color,
        fontFamily: 'Times New Roman',
        fontSize: width,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        decoration:
            underlined ? TextDecoration.underline : TextDecoration.none);

dynamic showToast(
    {required String txt,
    Color background = Colors.red,
    position = ToastGravity.BOTTOM}) {
  return Fluttertoast.showToast(
      msg: txt,
      toastLength: Toast.LENGTH_SHORT,
      gravity: position,
      timeInSecForIosWeb: 1,
      backgroundColor: background,
      textColor: Colors.white,
      fontSize: 16.0);
}
