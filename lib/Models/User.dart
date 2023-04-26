class User {
  final String name;
  final String nickName;
  final String bio;
  final int loves;
  final String profileSrc;
  final String uid;
  final String Email;
  final bool darkTheme;

  const User({
    required this.Email,
    required this.nickName,
    required this.bio,
    required this.profileSrc,
    required this.name,
    required this.loves,
    required this.uid,
    required this.darkTheme,
  });

  Map<String, dynamic> toJson() => {
        "username": name,
        "nikeName": nickName,
        "Email": Email,
        "bio": bio,
        "profileSrc": profileSrc,
        "uid": uid,
        "loves": loves,
        "darkTheme": darkTheme,
      };
}
