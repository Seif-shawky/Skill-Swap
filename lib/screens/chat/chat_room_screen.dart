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
      appBar: AppBar(
        title: Text(widget.thread.peerName),
        actions: [
          IconButton(
            tooltip: 'Complete swap',
            icon: const Icon(Icons.verified_outlined),
            onPressed: () => _openCompleteSwapDialog(context, state),
          ),
        ],
      ),
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

  Future<void> _openCompleteSwapDialog(BuildContext context, AppState state) async {
    final swapRequestId = widget.thread.swapRequestId;
    if (widget.thread.peerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat participant not resolved yet.')),
      );
      return;
    }
    if (swapRequestId == null || swapRequestId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Swap request not linked to this chat yet.')),
      );
      return;
    }

    final commentController = TextEditingController();
    var rating = 5;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Complete swap'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rate your swap partner'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (var value = 1; value <= 5; value++)
                        ChoiceChip(
                          label: Text('$value'),
                          selected: rating == value,
                          onSelected: (_) => setState(() => rating = value),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a short review (optional)',
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
    if (confirmed != true) {
      commentController.dispose();
      return;
    }

    final succeeded = await state.completeSwapAndReview(
      thread: widget.thread,
      rating: rating,
      comment: commentController.text,
    );
    commentController.dispose();
    if (!context.mounted) return;

    final message = succeeded ? 'Swap completed and rating sent.' : 'Unable to complete swap yet.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
