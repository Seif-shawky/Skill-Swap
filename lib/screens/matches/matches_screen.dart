import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../routes/route_names.dart';
import '../../widgets/skill_card.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final user = state.currentUser;
        final matches = state.recommendedListings;

        return Scaffold(
          appBar: AppBar(title: const Text('Smart matches')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Based on what you want', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final skill in user?.skillsWanted ?? const <String>[])
                            Chip(label: Text(skill), avatar: const Icon(Icons.search, size: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              for (final listing in matches)
                SkillCard(
                  listing: listing,
                  onTap: () => Navigator.pushNamed(context, RouteNames.listingDetail, arguments: listing),
                ),
            ],
          ),
        );
      },
    );
  }
}
