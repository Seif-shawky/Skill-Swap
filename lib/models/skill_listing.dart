import 'package:cloud_firestore/cloud_firestore.dart';

class SkillListing {
  const SkillListing({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.title,
    required this.category,
    required this.description,
    required this.skillLevel,
    required this.availability,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String ownerId;
  final String ownerName;
  final String title;
  final String category;
  final String description;
  final String skillLevel;
  final String availability;
  final String type;
  final DateTime createdAt;

  factory SkillListing.fromMap(String id, Map<String, dynamic> data) {
    final timestamp = data['createdAt'];
    return SkillListing(
      id: id,
      ownerId: data['ownerId'] as String? ?? '',
      ownerName: data['ownerName'] as String? ?? 'Student',
      title: data['title'] as String? ?? '',
      category: data['category'] as String? ?? 'General',
      description: data['description'] as String? ?? '',
      skillLevel: data['skillLevel'] as String? ?? 'Beginner',
      availability: data['availability'] as String? ?? 'Flexible',
      type: data['type'] as String? ?? 'offering',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'ownerName': ownerName,
      'title': title,
      'category': category,
      'description': description,
      'skillLevel': skillLevel,
      'availability': availability,
      'type': type,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static List<SkillListing> demoList() {
    final now = DateTime.now();
    return [
      SkillListing(
        id: '1',
        ownerId: 'user-1',
        ownerName: 'Mariam',
        title: 'Flutter screens and Firebase setup',
        category: 'Programming',
        description: 'I can help you build clean Flutter screens and connect auth or Firestore.',
        skillLevel: 'Intermediate',
        availability: 'Sun/Tue evenings',
        type: 'offering',
        createdAt: now,
      ),
      SkillListing(
        id: '2',
        ownerId: 'user-2',
        ownerName: 'Omar',
        title: 'Photoshop posters and social designs',
        category: 'Design',
        description: 'Trading Photoshop basics, poster composition, and export settings.',
        skillLevel: 'Advanced',
        availability: 'Weekends',
        type: 'offering',
        createdAt: now,
      ),
      SkillListing(
        id: '3',
        ownerId: 'user-3',
        ownerName: 'Nour',
        title: 'Presentation coaching',
        category: 'Communication',
        description: 'Practice your project pitch, slides flow, and Q&A answers.',
        skillLevel: 'Intermediate',
        availability: 'Flexible',
        type: 'offering',
        createdAt: now,
      ),
    ];
  }
}
