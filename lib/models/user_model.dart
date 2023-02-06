class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profileUrl;
  final String bio;
  final String bannerPic;
  final List<String> followers;
  final List<String> following;
  final bool isTwitterBlue;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileUrl,
    required this.bio,
    required this.isTwitterBlue,
    required this.bannerPic,
    required this.followers,
    required this.following,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileUrl,
    String? bio,
    bool? isTwitterBlue,
    String? bannerPic,
    List<String>? followers,
    List<String>? following,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileUrl: profileUrl ?? this.profileUrl,
      bio: bio ?? this.bio,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
      bannerPic: bannerPic ?? this.bannerPic,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'profileUrl': profileUrl,
      'bio': bio,
      'bannerPic': bannerPic,
      'followers': followers,
      'following': following,
      'isTwitterBlue': isTwitterBlue,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profileUrl: map['profileUrl'] ?? '',
      bio: map['bio'] ?? '',
      bannerPic: map['bannerPic'] ?? '',
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
      isTwitterBlue: map['isTwitterBlue'] ?? '',
    );
  }
}
