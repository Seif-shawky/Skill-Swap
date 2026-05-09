import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  const Review({
    required this.id,
    required this.swapRequestId,
    required this.fromUserId,
    required this.toUserId,
    required this.rating,
    required this.createdAt,
    this.comment,
  });

  final String id;
  final String swapRequestId;
  final String fromUserId;
  final String toUserId;
  final int rating;
  final DateTime createdAt;
  final String? comment;

  Map<String, dynamic> toMap() {
    return {
      'swapRequestId': swapRequestId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'rating': rating,
      if (comment != null && comment!.trim().isNotEmpty) 'comment': comment!.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
