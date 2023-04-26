import 'package:cloud_firestore/cloud_firestore.dart';

class TextPost {
  final String description;
  final String uid;
  final datePublished;
  final textArray;
  final postid;
  final type;
  final loves;

  const TextPost({
    required this.datePublished,
    required this.loves,
    required this.uid,
    required this.type,
    required this.postid,
    required this.textArray,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "loves": loves,
        "datePublished": datePublished,
        "textArray": textArray,
        "postid": postid,
        "uid": uid,
        "type": type
      };

  static TextPost fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TextPost(
      datePublished: snapshot["datePublished"],
      loves: snapshot["loves"],
      uid: snapshot["uid"],
      type: snapshot["type"],
      postid: snapshot["postid"],
      textArray: snapshot["textArray"],
      description: snapshot["description"],
    );
  }
}
