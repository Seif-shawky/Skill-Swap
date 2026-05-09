import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../models/skill_listing.dart';
import '../models/swap_request.dart';

class SwapRequestService {
  SwapRequestService({required this.firebaseReady});

  final bool firebaseReady;

  Future<bool> createRequest({
    required AppUser requester,
    required SkillListing listing,
    String? message,
  }) async {
    if (!firebaseReady) return false;
    final request = SwapRequest(
      id: '',
      listingId: listing.id,
      listingTitle: listing.title,
      listingOwnerId: listing.ownerId,
      listingOwnerName: listing.ownerName,
      requesterId: requester.uid,
      requesterName: requester.name,
      status: 'pending',
      createdAt: DateTime.now(),
      message: message,
    );
    final firestore = FirebaseFirestore.instance;
    final requestRef = await firestore.collection('swapRequests').add(request.toMap());
    await _ensureChatThread(
      firestore: firestore,
      requester: requester,
      listing: listing,
      swapRequestId: requestRef.id,
    );
    return true;
  }

  Future<void> markCompleted(String swapRequestId) async {
    if (!firebaseReady) return;
    await FirebaseFirestore.instance.collection('swapRequests').doc(swapRequestId).update({
      'status': 'completed',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _ensureChatThread({
    required FirebaseFirestore firestore,
    required AppUser requester,
    required SkillListing listing,
    required String swapRequestId,
  }) async {
    final chatId = _chatIdFor(listingId: listing.id, a: requester.uid, b: listing.ownerId);
    final chatRef = firestore.collection('chats').doc(chatId);
    final chatSnap = await chatRef.get();
    if (chatSnap.exists) {
      await chatRef.set({
        'participantIds': [listing.ownerId, requester.uid],
        'participantNames': {
          listing.ownerId: listing.ownerName,
          requester.uid: requester.name,
        },
        'listingId': listing.id,
        'listingTitle': listing.title,
        'swapRequestId': swapRequestId,
      }, SetOptions(merge: true));
      return;
    }

    final initialMessage = 'Swap request from ${requester.name} for ${listing.title}.';
    await chatRef.set({
      'participantIds': [listing.ownerId, requester.uid],
      'participantNames': {
        listing.ownerId: listing.ownerName,
        requester.uid: requester.name,
      },
      'listingId': listing.id,
      'listingTitle': listing.title,
      'swapRequestId': swapRequestId,
      'lastMessage': initialMessage,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    await chatRef.collection('messages').add({
      'senderId': requester.uid,
      'text': initialMessage,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  String _chatIdFor({required String listingId, required String a, required String b}) {
    final ids = [a, b]..sort();
    return 'listing_${listingId}_${ids[0]}_${ids[1]}';
  }
}
