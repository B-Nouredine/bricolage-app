import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:bricolage_app/constants.dart';
import 'package:bricolage_app/models/Post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../enums.dart';
import 'DetailsScreen.dart';
import 'components/Post_card.dart';
import 'components/Bottom_Nav_Bar.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  List<Post> Posts = List.empty(growable: true);
  bool showSpinner = false;
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("MyPosts", style: TextStyle(fontSize: 18)),
      ),
      body: showSpinner
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                      children: Posts.map((post) => Stack(
                          children: [
                            Container(
                              margin:
                              const EdgeInsets.only(top: 14),
                              padding:const EdgeInsets.symmetric(horizontal: 20) ,
                              child: PostCard(
                                post: post,
                                press: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsScreen(
                                          post: post,
                                        ))),
                              ),
                            ),
                            Container(
                                alignment: Alignment.topRight,
                                margin:EdgeInsets.only(right: 8),
                                child: RawMaterialButton(
                                  padding: EdgeInsets.all(6),
                                  constraints: BoxConstraints(),
                                  child: const Icon(
                                      IconData(0xe16a,
                                          fontFamily: 'MaterialIcons'),
                                      color: Colors.white),
                                  fillColor: Colors.blue,
                                  onPressed: () =>deletePost(post),
                                  shape: const CircleBorder(),
                                )),
                          ])).toList(),
              ),
            ),
      bottomNavigationBar: const BottomNavBar(selectedMenu: MenuState.myPosts),
    );
  }

  void getData() async {
    showSpinner = true;
    QuerySnapshot querySnapshot = await firestore
        .collection("posts")
        .where("userId", isEqualTo: auth.currentUser?.uid)
        .orderBy('createdAt', descending: true)
        .get();
    setState(() {
      if (querySnapshot.docs.isNotEmpty) {
        Posts = Post.getPosts(querySnapshot);
      }
      showSpinner = false;
    });
  }

 void  deletePost(Post post) async {
   await firestore
       .collection("posts").doc(post.id).delete();
    setState(() {
      Posts.remove(post);
    });
 }
}
