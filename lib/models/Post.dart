import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String image, title, description;
  final String location, id, userId, category;
  final int price, rating;
  final int duration;
  Timestamp createdAt;
  Post({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.rating,
    required this.duration,
    required this.location,
    required this.createdAt,
    required this.userId,
    required this.category,
  });

  static List<Post> getPosts(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((doc) => Post(
            id: doc.id,
            title: doc.get('title'),
            description: doc.get('description'),
            duration: doc.get('duration'),
            location: doc.get('location'),
            price: doc.get('price'),
            rating: 2,
            image: "assets/images/${doc.get('category')}.png",
            createdAt: doc.get('createdAt'),
            userId: doc.get('userId'),
            category: doc.get("category")))
        .toList();
  }
}
/*

List<Post> posts = [
  Post(
      id: "1",
      title: "Office Code",
      price: 234,
      rating: 5,
      description: dummyText,
      image: "assets/images/cleaning.png",
      duration: 9,
      location: 'FES'
  ),
  Post(
      id: "2",
      title: "Belt Bag",
      price: 234,
      rating: 8,
      description: dummyText,
      image: "assets/images/back.jpeg",
      duration: 3,
      location: 'FES'
  ),

  Post(
      id: "3",
      title: "Hang Top",
      price: 234,
      rating: 10,
      description: dummyText,
      image: "assets/images/back.jpeg",
      duration: 3,
      location: 'FES'),
  Post(
      id: "4",
      title: "Old Fashion",
      price: 234,
      rating: 11,
      description: dummyText,
      image: "assets/images/back.jpeg",
      duration: 3,
      location: 'FES'),
  Post(
      id: "5",
      title: "Office Code",
      price: 234,
      rating: 12,
      description: dummyText,
      image: "assets/images/back.jpeg",
      duration: 3,
      location: 'FES'),
  Post(
    id: "6",
    title: "Office Code",
    price: 234,
    rating: 12,
    description: dummyText,
    image: "assets/images/back.jpeg",
      duration: 3,
      location: 'FES'
  ),
];
String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry";
*/
