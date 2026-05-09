import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _category = TextEditingController(text: 'Programming');
  final _description = TextEditingController();
  final _availability = TextEditingController(text: 'Flexible');
  String _level = 'Beginner';
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create listing')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Skill title', prefixIcon: Icon(Icons.title)),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _category,
              decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category_outlined)),
              validator: _required,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _level,
              decoration: const InputDecoration(labelText: 'Skill level', prefixIcon: Icon(Icons.stairs_outlined)),
              items: const ['Beginner', 'Intermediate', 'Advanced'].map((level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              onChanged: (value) => setState(() => _level = value!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _availability,
              decoration: const InputDecoration(labelText: 'Availability', prefixIcon: Icon(Icons.schedule)),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
              validator: _required,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _busy ? null : _save,
              icon: const Icon(Icons.publish_outlined),
              label: Text(_busy ? 'Publishing...' : 'Publish listing'),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) => value == null || value.trim().isEmpty ? 'Required' : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    await context.read<AppState>().createListing(
          title: _title.text.trim(),
          category: _category.text.trim(),
          description: _description.text.trim(),
          skillLevel: _level,
          availability: _availability.text.trim(),
        );
    if (!mounted) return;
    Navigator.pop(context);
  }
}
