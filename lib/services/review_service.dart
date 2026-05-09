import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review.dart';

class ReviewService {
  ReviewService({required this.firebaseReady});

  final bool firebaseReady;

  Future<void> submitReview({
    required String swapRequestId,
    required String fromUserId,
    required String toUserId,
    required int rating,
    String? comment,
  }) async {
    if (!firebaseReady) return;

    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('users').doc(toUserId);
    final reviewRef = firestore.collection('reviews').doc();

    await firestore.runTransaction((transaction) async {
      final userSnap = await transaction.get(userRef);
      final data = userSnap.data() ?? {};
      final currentAvg = (data['ratingAvg'] as num? ?? 0).toDouble();
      final currentCount = (data['ratingCount'] as num? ?? 0).toInt();
      final nextCount = currentCount + 1;
      final nextAvg = ((currentAvg * currentCount) + rating) / nextCount;

      transaction.update(userRef, {
        'ratingAvg': nextAvg,
        'ratingCount': nextCount,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final review = Review(
        id: reviewRef.id,
        swapRequestId: swapRequestId,
        fromUserId: fromUserId,
        toUserId: toUserId,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );
      transaction.set(reviewRef, review.toMap());
    });
  }
}
