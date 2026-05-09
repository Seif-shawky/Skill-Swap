import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message.dart';
import '../models/chat_thread.dart';

class ChatService {
  ChatService({required this.firebaseReady});

  final bool firebaseReady;

  Stream<List<ChatThread>> watchThreads(String userId) {
    if (!firebaseReady) {
      return Stream.value(ChatThread.demoList());
    }

    return FirebaseFirestore.instance
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final timestamp = data['lastMessageAt'];
        final peerName = _resolvePeerName(data, userId);
        final peerId = _resolvePeerId(data, userId);
        return ChatThread(
          id: doc.id,
          peerId: peerId,
          peerName: peerName,
          lastMessage: data['lastMessage'] as String? ?? '',
          lastMessageAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
          listingId: data['listingId'] as String?,
          listingTitle: data['listingTitle'] as String?,
          swapRequestId: data['swapRequestId'] as String?,
        );
      }).toList();
    });
  }

  String _resolvePeerName(Map<String, dynamic> data, String userId) {
    final names = data['participantNames'];
    if (names is Map) {
      final entries = names.entries
          .map((entry) => MapEntry(entry.key.toString(), entry.value.toString()))
          .toList();
      if (entries.isNotEmpty) {
        final peerEntry = entries.firstWhere(
          (entry) => entry.key != userId,
          orElse: () => entries.first,
        );
        return peerEntry.value;
      }
    }
    return data['peerName'] as String? ?? 'Student';
  }

  String _resolvePeerId(Map<String, dynamic> data, String userId) {
    final participants = data['participantIds'];
    if (participants is List) {
      final ids = participants.map((value) => value.toString()).toList();
      if (ids.isNotEmpty) {
        final peerId = ids.firstWhere(
          (id) => id != userId,
          orElse: () => ids.first,
        );
        return peerId;
      }
    }
    return '';
  }

  Stream<List<ChatMessage>> watchMessages(String chatId, String userId) {
    if (!firebaseReady) {
      return Stream.value(ChatMessage.demoMessages(userId));
    }

    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final timestamp = data['createdAt'];
        return ChatMessage(
          id: doc.id,
          senderId: data['senderId'] as String? ?? '',
          text: data['text'] as String? ?? '',
          createdAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
        );
      }).toList();
    });
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    if (!firebaseReady || text.trim().isEmpty) return;
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
    await chatRef.collection('messages').add({
      'senderId': senderId,
      'text': text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    await chatRef.update({
      'lastMessage': text.trim(),
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }
}
