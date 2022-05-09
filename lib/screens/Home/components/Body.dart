import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bricolage_app/models/Post.dart';
import 'package:bricolage_app/screens/Home/DetailsScreen.dart';
import 'package:bricolage_app/screens/Home/Filter.dart';
import '../../../constants.dart';
import 'Post_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int selectedIndex = 999;
  List<Post> Posts = List.empty(growable: true);
  List<Post> categoryPosts = List.empty(growable: true);
  final _scrollController = ScrollController();
  bool showSpinner = false;
  bool needMoreData = false;
  bool noMoreData = false;
  late QueryDocumentSnapshot firstDocumentSnapshot;
  late QueryDocumentSnapshot lastDocumentSnapshot;
  String searchValue="";
  @override
  void initState() {
    if (Posts.isEmpty) {
      getData();
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >
                _scrollController.position.maxScrollExtent / 2 &&
            noMoreData == false) {
          setState(() {
            needMoreData = true;
          });
          getMoreData();
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showSpinner
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
        : RefreshIndicator(
            color: Colors.blue,
            onRefresh: refreshData,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            displacement: 70,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        const Spacer(),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child:TextField(
                            onChanged: (value){
                              searchValue=value;
                            },
                            onSubmitted:(value) {
                              Search();
                            },
                            decoration: const InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.search,color: Colors.black54),
                            ),

                          ),
                        ),
                            flex: 11),
                        const Spacer(flex: 1),
                        Container(
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                              splashColor: Colors.black54,
                              splashRadius: 23,
                              onPressed: () => FilterData(),
                              icon: const Icon(Icons.filter_alt),
                              iconSize: 30.0),
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: kDefaultPadding,
                        bottom: kDefaultPadding,
                        right: kDefaultPadding / 2),
                    child: SizedBox(
                      height: 25,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        padEnds: false,
                        controller: PageController(viewportFraction: 0.35),
                        itemCount: kcategories.length,
                        itemBuilder: (context, index) => buildCategory(index),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: Column(
                      children: categoryPosts.map((post) => PostCard(
                            post: post,
                            press: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                          post: post,
                                        ))),
                          )).toList(),
                    ),
                  ),
                  needMoreData
                      ? const SizedBox(
                          height: 90,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 45.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(width: 0),
                ],
              ),
            ),
          );
  }
  void getCategorieData(){
      if(selectedIndex<kcategories.length) {
        setState(() {
          categoryPosts = Posts.where((element) => element.category ==
              kcategories[selectedIndex]).toList();
        });
      }
      if(selectedIndex==999){
        setState(() {
          categoryPosts=Posts;
        });
      }
  }
  void getData() async {
    showSpinner = true;
    QuerySnapshot querySnapshot = await firestore
        .collection("posts")
        .orderBy('createdAt', descending: true)
        .limit(5)
        .get();
    setState(() {
      if (querySnapshot.docs.isNotEmpty) {
        firstDocumentSnapshot = querySnapshot.docs.first;
        lastDocumentSnapshot = querySnapshot.docs.last;
        Posts = Post.getPosts(querySnapshot);
      }
      showSpinner = false;
    });
    getCategorieData();
  }

  Future<void> refreshData() async {
    QuerySnapshot querySnapshot = await firestore
        .collection("posts")
        .orderBy('createdAt', descending: true)
        .endBeforeDocument(firstDocumentSnapshot)
        .limit(5)
        .get();
    setState(() {
      firstDocumentSnapshot = querySnapshot.docs.first;
      Posts.insertAll(0, Post.getPosts(querySnapshot));
    });
    getCategorieData();
    return Future.delayed(const Duration(seconds: 0));
  }

  void getMoreData() async {
    noMoreData = true;
    QuerySnapshot querySnapshot = await firestore
        .collection("posts")
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastDocumentSnapshot)
        .limit(5)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        lastDocumentSnapshot = querySnapshot.docs.last;
        Posts.insertAll(Posts.length, Post.getPosts(querySnapshot));
        needMoreData = false;
        noMoreData = false;
      });
      getCategorieData();
    } else {
      setState(() {
        needMoreData = false;
        noMoreData = true;
      });
    }
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        getCategorieData();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            kcategories[index],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selectedIndex == index ? kOrangeColor : inActiveIconColor,
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(top: kDefaultPadding / 4), //top padding 5
            height: 2,
            width: 40,
            color:
                selectedIndex == index ? Colors.lightGreen : Colors.transparent,
          )
        ],
      ),
    );
  }

  FilterData() async{
    final List result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilterScreen(),
        ));
    RangeValues range = result[1];
    setState(() {
      selectedIndex=1000;
      categoryPosts=List.empty(growable: true);
       for (var category in result[0]) {
         categoryPosts.addAll(Posts.where((element) =>
          element.category == category && element.price > range.start
            && element.price < range.end).toList());
      }
    });
  }
  void Search() {
    setState(() {
      selectedIndex=1000;
        categoryPosts=Posts.where((element) =>
        element.category.contains(searchValue) || element.description.contains(searchValue)
        || element.location.contains(searchValue) || element.title.contains(searchValue)).toList();
  });
        }
}



