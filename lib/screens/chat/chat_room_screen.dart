import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_thread.dart';
import '../../providers/app_state.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.thread});

  final ChatThread thread;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final userId = state.currentUser?.uid ?? 'demo-user';

    return Scaffold(
      appBar: AppBar(title: Text(widget.thread.peerName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: state.chatService.watchMessages(widget.thread.id, userId),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? const [];
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final mine = message.senderId == userId;
                    return Align(
                      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: const BoxConstraints(maxWidth: 320),
                        decoration: BoxDecoration(
                          color: mine ? Theme.of(context).colorScheme.primary : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(color: mine ? Colors.white : const Color(0xFF0F172A)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _message,
                      decoration: const InputDecoration(hintText: 'Message about your skill swap'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Send message',
                    onPressed: () async {
                      await state.chatService.sendMessage(
                        chatId: widget.thread.id,
                        senderId: userId,
                        text: _message.text,
                      );
                      _message.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
