class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profileUrl;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileUrl,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'profileUrl': profileUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profileUrl: map['profileUrl'] as String,
    );
  }
}
