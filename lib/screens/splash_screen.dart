import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../routes/route_names.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted || state.isLoading) return;
          Navigator.pushReplacementNamed(
            context,
            state.isLoggedIn ? RouteNames.shell : RouteNames.login,
          );
        });

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.swap_horiz, color: Colors.white, size: 42),
                ),
                const SizedBox(height: 18),
                Text(
                  'SkillSwap',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text('Trade skills. Build together.'),
              ],
            ),
          ),
        );
      },
    );
  }
}
