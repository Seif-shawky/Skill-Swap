import 'package:flutter/material.dart';

import '../models/chat_thread.dart';
import '../models/skill_listing.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/chat/chat_room_screen.dart';
import '../screens/home/create_listing_screen.dart';
import '../screens/home/listing_detail_screen.dart';
import '../screens/home/main_shell.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/splash_screen.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) {
        switch (settings.name) {
          case RouteNames.splash:
            return const SplashScreen();
          case RouteNames.login:
            return const LoginScreen();
          case RouteNames.signup:
            return const SignupScreen();
          case RouteNames.shell:
            return const MainShell();
          case RouteNames.createListing:
            return const CreateListingScreen();
          case RouteNames.editProfile:
            return const EditProfileScreen();
          case RouteNames.listingDetail:
            return ListingDetailScreen(listing: settings.arguments! as SkillListing);
          case RouteNames.chatRoom:
            return ChatRoomScreen(thread: settings.arguments! as ChatThread);
          default:
            return const _UnknownRouteScreen();
        }
      },
    );
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Route not found')),
    );
  }
}
