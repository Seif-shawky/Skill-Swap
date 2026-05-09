import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.skillsOffered,
    required this.skillsWanted,
    required this.ratingAvg,
    required this.ratingCount,
  });

  final String uid;
  final String name;
  final String email;
  final String bio;
  final List<String> skillsOffered;
  final List<String> skillsWanted;
  final double ratingAvg;
  final int ratingCount;

  factory AppUser.demo() {
    return const AppUser(
      uid: 'demo-user',
      name: 'Seif Student',
      email: 'student@university.edu',
      bio: 'Computer science student trading Flutter help for design lessons.',
      skillsOffered: ['Flutter', 'Firebase', 'Dart'],
      skillsWanted: ['Photoshop', 'Public Speaking', 'UI Design'],
      ratingAvg: 4.8,
      ratingCount: 12,
    );
  }

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      name: data['name'] as String? ?? 'Student',
      email: data['email'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      skillsOffered: List<String>.from(data['skillsOffered'] as List? ?? const []),
      skillsWanted: List<String>.from(data['skillsWanted'] as List? ?? const []),
      ratingAvg: (data['ratingAvg'] as num? ?? 0).toDouble(),
      ratingCount: (data['ratingCount'] as num? ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'skillsOffered': skillsOffered,
      'skillsWanted': skillsWanted,
      'ratingAvg': ratingAvg,
      'ratingCount': ratingCount,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  AppUser copyWith({
    String? name,
    String? bio,
    List<String>? skillsOffered,
    List<String>? skillsWanted,
    double? ratingAvg,
    int? ratingCount,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email,
      bio: bio ?? this.bio,
      skillsOffered: skillsOffered ?? this.skillsOffered,
      skillsWanted: skillsWanted ?? this.skillsWanted,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }
}
