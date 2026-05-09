import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../routes/route_names.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Edit profile',
            onPressed: () => Navigator.pushNamed(context, RouteNames.editProfile),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('No profile loaded'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        CircleAvatar(radius: 38, child: Text(user.name.characters.first.toUpperCase())),
                        const SizedBox(height: 12),
                        Text(user.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                        Text(user.email),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 4),
                            Text('${user.ratingAvg.toStringAsFixed(1)} (${user.ratingCount} reviews)'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _Section(title: 'Bio', child: Text(user.bio.isEmpty ? 'Add a short student bio.' : user.bio)),
                _Section(
                  title: 'I can teach',
                  child: _SkillWrap(skills: user.skillsOffered, icon: Icons.school_outlined),
                ),
                _Section(
                  title: 'I want to learn',
                  child: _SkillWrap(skills: user.skillsWanted, icon: Icons.lightbulb_outline),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    await state.signOut();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (_) => false);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Log out'),
                ),
              ],
            ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _SkillWrap extends StatelessWidget {
  const _SkillWrap({required this.skills, required this.icon});

  final List<String> skills;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const Text('No skills added yet.');
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final skill in skills) Chip(label: Text(skill), avatar: Icon(icon, size: 16)),
      ],
    );
  }
}
