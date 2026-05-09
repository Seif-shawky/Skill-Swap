import 'package:cloud_firestore/cloud_firestore.dart';

class SwapRequest {
  const SwapRequest({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.listingOwnerId,
    required this.listingOwnerName,
    required this.requesterId,
    required this.requesterName,
    required this.status,
    required this.createdAt,
    this.message,
  });

  final String id;
  final String listingId;
  final String listingTitle;
  final String listingOwnerId;
  final String listingOwnerName;
  final String requesterId;
  final String requesterName;
  final String status;
  final DateTime createdAt;
  final String? message;

  factory SwapRequest.fromMap(String id, Map<String, dynamic> data) {
    final timestamp = data['createdAt'];
    return SwapRequest(
      id: id,
      listingId: data['listingId'] as String? ?? '',
      listingTitle: data['listingTitle'] as String? ?? '',
      listingOwnerId: data['listingOwnerId'] as String? ?? '',
      listingOwnerName: data['listingOwnerName'] as String? ?? 'Student',
      requesterId: data['requesterId'] as String? ?? '',
      requesterName: data['requesterName'] as String? ?? 'Student',
      status: data['status'] as String? ?? 'pending',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
      message: data['message'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'listingId': listingId,
      'listingTitle': listingTitle,
      'listingOwnerId': listingOwnerId,
      'listingOwnerName': listingOwnerName,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'status': status,
      if (message != null && message!.trim().isNotEmpty) 'message': message!.trim(),
      'participantIds': [listingOwnerId, requesterId],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
