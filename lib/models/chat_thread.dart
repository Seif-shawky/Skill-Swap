class ChatThread {
  const ChatThread({
    required this.id,
    required this.peerId,
    required this.peerName,
    required this.lastMessage,
    required this.lastMessageAt,
    this.listingId,
    this.listingTitle,
    this.swapRequestId,
  });

  final String id;
  final String peerId;
  final String peerName;
  final String lastMessage;
  final DateTime lastMessageAt;
  final String? listingId;
  final String? listingTitle;
  final String? swapRequestId;

  static List<ChatThread> demoList() {
    return [
      ChatThread(
        id: 'demo-chat-1',
        peerId: 'demo-peer-1',
        peerName: 'Omar',
        lastMessage: 'Can we swap Flutter help for Photoshop tomorrow?',
        lastMessageAt: DateTime.now().subtract(const Duration(minutes: 12)),
        listingTitle: 'Flutter tutoring',
      ),
      ChatThread(
        id: 'demo-chat-2',
        peerId: 'demo-peer-2',
        peerName: 'Nour',
        lastMessage: 'Your presentation outline looks much stronger now.',
        lastMessageAt: DateTime.now().subtract(const Duration(hours: 3)),
        listingTitle: 'Presentation coaching',
      ),
    ];
  }
}
