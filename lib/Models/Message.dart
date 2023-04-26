class Message {
  final String message;
  final String uid;
  final datePublished;
  final String sentby;
  final bool header;
  final bool filePost;
  final bool textPost;
  final bool newUSer;
  final String linkID;

  const Message(
      {
        required this.message,
        required this.uid,
        required this.header,
        required this.linkID,
        required this.datePublished,
        required this.sentby,
        required this.filePost,
        required this.newUSer,
        required this.textPost,
      });

  Map<String, dynamic> toJson() => {
        "message": message,
        "uid": uid,
        "header": header,
        "linkID": linkID,
        "datePublished": datePublished,
        "sentBy": sentby,
        "filePost": filePost,
        "newUser": newUSer,
        "textPost": textPost,
      };
}
