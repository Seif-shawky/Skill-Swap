import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../routes/route_names.dart';
import '../../widgets/skill_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final listings = state.listings.where((listing) {
          final text = '${listing.title} ${listing.category} ${listing.description}'.toLowerCase();
          return text.contains(_query.toLowerCase());
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Skill marketplace'),
            actions: [
              IconButton(
                tooltip: 'Create listing',
                onPressed: () => Navigator.pushNamed(context, RouteNames.createListing),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Search Flutter, Photoshop, public speaking...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 18),
              _SummaryStrip(total: state.listings.length, matches: state.recommendedListings.length),
              const SizedBox(height: 18),
              Text('Recommended for you', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              for (final listing in state.recommendedListings)
                SkillCard(
                  listing: listing,
                  onTap: () => Navigator.pushNamed(context, RouteNames.listingDetail, arguments: listing),
                ),
              const SizedBox(height: 12),
              Text('All skills', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              if (listings.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No skills found yet. Create the first listing.')),
                )
              else
                for (final listing in listings)
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

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.total, required this.matches});

  final int total;
  final int matches;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: _Metric(label: 'Listings', value: '$total', color: colors.primary)),
        const SizedBox(width: 10),
        Expanded(child: _Metric(label: 'Matches', value: '$matches', color: colors.secondary)),
        const SizedBox(width: 10),
        Expanded(child: _Metric(label: 'Mode', value: 'Swap', color: colors.tertiary)),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w900)),
          Text(label, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
