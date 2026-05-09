import 'package:flutter/material.dart';

import '../../models/skill_listing.dart';

class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({super.key, required this.listing});

  final SkillListing listing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(listing.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(listing.category)),
              Chip(label: Text(listing.skillLevel)),
              Chip(label: Text(listing.availability)),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(child: Text(listing.ownerName.characters.first.toUpperCase())),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listing.ownerName, style: const TextStyle(fontWeight: FontWeight.w800)),
                      const Text('SkillSwap student'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('What you will learn', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(listing.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Swap request created for the demo. Connect Firebase to persist it.')),
              );
            },
            icon: const Icon(Icons.handshake_outlined),
            label: const Text('Request skill swap'),
          ),
        ],
      ),
    );
  }
}
