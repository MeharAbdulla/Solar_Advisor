class UserProfile {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String? location;
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.location,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'displayName': displayName,
    'email': email,
    'photoUrl': photoUrl,
    'location': location,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    uid: json['uid'] as String,
    displayName: json['displayName'] as String?,
    email: json['email'] as String?,
    photoUrl: json['photoUrl'] as String?,
    location: json['location'] as String?,
    createdAt: json['createdAt'] != null
      ? DateTime.parse(json['createdAt'] as String)
      : DateTime.now(),
  );
}
