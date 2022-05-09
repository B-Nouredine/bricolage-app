import 'package:flutter/material.dart';
import 'package:bricolage_app/constants.dart';
import 'package:bricolage_app/models/Post.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final Post post;
  final Function()? press;
  const PostCard({
    Key? key, required this.post, this.press,
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness==Brightness.dark;
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:kDefaultPadding/4),
        child: Container(
          height: 225,
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              color: darkMode?Colors.white24 : Colors.black26,
              borderRadius: BorderRadius.circular(8.0),
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 122.0,
                child: Row(
                  children: [
                      Hero(
                        tag: post.id,
                        child: Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                  image: AssetImage(post.image),
                                    fit: BoxFit.cover,
                                ),
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                          ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold ,fontSize: 26),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                timeago.format(post.createdAt.toDate()),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 7),
                              const Text(
                                  "Rating ⭐⭐⭐⭐",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                      post.description,
                                       overflow:TextOverflow.ellipsis,
                                       maxLines: 3,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                 ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: darkMode?Colors.black26 :Colors.white38,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 17,vertical: 7),
                      child: Text(
                        "\$${post.price}",
                        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: darkMode?Colors.black26 :Colors.white38,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 17,vertical: 7),
                      child: Text(
                          post.location,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: darkMode?Colors.black26 :Colors.white38,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 17,vertical: 7),
                      child: Text(
                         "${post.duration} min",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ) ,
              )
            ],
          ),
        ),
      ),
    );
  }
}






















