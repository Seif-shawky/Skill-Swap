import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state.dart';
import 'routes/app_router.dart';
import 'routes/route_names.dart';
import 'services/auth_service.dart';
import 'services/cache_service.dart';
import 'services/chat_service.dart';
import 'services/skill_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseReady = true;
  try {
    await Firebase.initializeApp();
  } catch (_) {
    firebaseReady = false;
  }

  final cacheService = CacheService();
  await cacheService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: cacheService),
        Provider(create: (_) => AuthService(firebaseReady: firebaseReady)),
        Provider(create: (_) => SkillService(firebaseReady: firebaseReady, cacheService: cacheService)),
        Provider(create: (_) => ChatService(firebaseReady: firebaseReady)),
        ChangeNotifierProvider(
          create: (context) => AppState(
            authService: context.read<AuthService>(),
            skillService: context.read<SkillService>(),
            chatService: context.read<ChatService>(),
          )..bootstrap(),
        ),
      ],
      child: const SkillSwapApp(),
    ),
  );
}

class SkillSwapApp extends StatelessWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillSwap',
      theme: AppTheme.light,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
