import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../providers/app_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _bio;
  late final TextEditingController _offered;
  late final TextEditingController _wanted;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().currentUser ?? AppUser.demo();
    _name = TextEditingController(text: user.name);
    _bio = TextEditingController(text: user.bio);
    _offered = TextEditingController(text: user.skillsOffered.join(', '));
    _wanted = TextEditingController(text: user.skillsWanted.join(', '));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bio,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Bio', alignLabelWithHint: true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _offered,
            decoration: const InputDecoration(labelText: 'Skills offered', helperText: 'Separate skills with commas'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _wanted,
            decoration: const InputDecoration(labelText: 'Skills wanted', helperText: 'Separate skills with commas'),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save profile'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final state = context.read<AppState>();
    final current = state.currentUser ?? AppUser.demo();
    final updated = current.copyWith(
      name: _name.text.trim(),
      bio: _bio.text.trim(),
      skillsOffered: _splitSkills(_offered.text),
      skillsWanted: _splitSkills(_wanted.text),
    );
    await state.updateProfile(updated);
    if (!mounted) return;
    Navigator.pop(context);
  }

  List<String> _splitSkills(String value) {
    return value
        .split(',')
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toSet()
        .toList();
  }
}
