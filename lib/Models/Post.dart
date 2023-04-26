import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postid;
  final datePublished;
  final postURL;
  final type;
  final String profImg;
  final loves;
  final viewed;

  const Post({
    required this.datePublished,
    required this.viewed,
    required this.loves,
    required this.type,
    required this.postid,
    required this.postURL,
    required this.uid,
    required this.description,
    required this.profImg,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "profImg": profImg,
        "loves": loves,
        "postURL": postURL,
        "type": type,
        "postid": postid,
        "viewed": viewed,
        "datePublished": datePublished,
        "uid": uid,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        datePublished: snapshot["datePublished"],
        loves: snapshot["loves"],
        postid: snapshot["postId"],
        postURL: snapshot["postURL"],
        type: snapshot["type"],
        uid: snapshot["uid"],
        viewed: snapshot["viewed"],
        description: snapshot["description"],
        profImg: snapshot["profImg"]);
  }
}
