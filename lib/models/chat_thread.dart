class ChatThread {
  const ChatThread({
    required this.id,
    required this.peerName,
    required this.lastMessage,
    required this.lastMessageAt,
  });

  final String id;
  final String peerName;
  final String lastMessage;
  final DateTime lastMessageAt;

  static List<ChatThread> demoList() {
    return [
      ChatThread(
        id: 'demo-chat-1',
        peerName: 'Omar',
        lastMessage: 'Can we swap Flutter help for Photoshop tomorrow?',
        lastMessageAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      ChatThread(
        id: 'demo-chat-2',
        peerName: 'Nour',
        lastMessage: 'Your presentation outline looks much stronger now.',
        lastMessageAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];
  }
}
