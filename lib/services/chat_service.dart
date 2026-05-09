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
        return ChatThread(
          id: doc.id,
          peerName: data['peerName'] as String? ?? 'Student',
          lastMessage: data['lastMessage'] as String? ?? '',
          lastMessageAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
        );
      }).toList();
    });
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
