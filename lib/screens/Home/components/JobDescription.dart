import 'package:flutter/material.dart';
import 'package:bricolage_app/constants.dart';
import 'package:bricolage_app/models/Post.dart';

class JobDescription extends StatelessWidget {
  final Post post;
  final Size size;
  const JobDescription({Key? key, required this.post, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness==Brightness.dark;
    return  Container(
      constraints: BoxConstraints(minHeight: size.height*0.7),
      margin: EdgeInsets.only(top: size.height * 0.3),
      padding: EdgeInsets.only(
        top: size.height * 0.1+15,
        left: kDefaultPadding+5,
        right: kDefaultPadding,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkMode? kdarkColor : kSecondaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                post.title,
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30)
              ),
              Text(
                "\$${post.price}",
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 10.0),
              Text(
                post.location,
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
              ),
            ],
          ),
           const SizedBox(height: 10.0),

          const Text(
            "Rating ⭐⭐⭐⭐",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Text(
            post.description,
            style: const TextStyle(height: 1.5,fontSize: 16),
          ),
          SizedBox(height: 30.0)
        ],
      ),
    );
  }
}
