import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../routes/route_names.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Chats')),
          body: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.chatThreads.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final thread = state.chatThreads[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(thread.peerName.characters.first.toUpperCase())),
                  title: Text(thread.peerName, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(thread.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text(DateFormat('h:mm a').format(thread.lastMessageAt)),
                  onTap: () => Navigator.pushNamed(context, RouteNames.chatRoom, arguments: thread),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
