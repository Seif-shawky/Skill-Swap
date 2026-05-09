class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String senderId;
  final String text;
  final DateTime createdAt;

  static List<ChatMessage> demoMessages(String currentUserId) {
    return [
      ChatMessage(
        id: 'm1',
        senderId: 'peer',
        text: 'Hey! I saw you teach Flutter.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      ChatMessage(
        id: 'm2',
        senderId: currentUserId,
        text: 'Yes, I can help with screens and Firebase.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
      ),
      ChatMessage(
        id: 'm3',
        senderId: 'peer',
        text: 'Perfect. I can teach Photoshop poster design.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ];
  }
}
