import 'package:flutter/material.dart';

import '../models/skill_listing.dart';

class SkillCard extends StatelessWidget {
  const SkillCard({
    super.key,
    required this.listing,
    required this.onTap,
  });

  final SkillListing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      listing.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Chip(
                    label: Text(listing.category),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: colors.primaryContainer,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                listing.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 18, color: colors.primary),
                  const SizedBox(width: 6),
                  Text(listing.ownerName),
                  const Spacer(),
                  Icon(Icons.schedule, size: 18, color: colors.secondary),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      listing.availability,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
