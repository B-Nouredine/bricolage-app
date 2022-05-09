
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bricolage_app/constants.dart';
import 'package:bricolage_app/models/Post.dart';
import 'package:bricolage_app/screens/Home/components/ContactInfo.dart';
import 'package:bricolage_app/screens/Home/components/JobDescription.dart';

import 'components/default_button.dart';


class DetailsScreen extends StatelessWidget {
  final Post post;
  const DetailsScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final darkMode = Theme.of(context).brightness==Brightness.dark;
    return Scaffold(
          body:SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: post.id,
                  child: Container(
                    height: size.height * 0.38,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(post.image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              JobDescription(post: post, size: size),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor:darkMode? kdarkColor : kSecondaryColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/images/BackIcon.svg",
                      height: 23,
                      color: Colors.black87,
                    ),
                  ),
                ),
            ContactInfo(post: post, size: size)
              ],
            ),
          ),
     /* bottomNavigationBar: DefaultButton(
        text: "Send Request",
        press: () {},
      ),*/
    );
  }
}
