import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/feed_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'services/video_service.dart';
import 'theme/app_theme.dart';

void main() {
  final api = ApiClient();
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: api),
        ChangeNotifierProvider(create: (_) => AuthService(api)),
        Provider(create: (_) => VideoService(api)),
      ],
      child: const GakkoseiApp(),
    ),
  );
}

class GakkoseiApp extends StatelessWidget {
  const GakkoseiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gakkosei',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Consumer<AuthService>(
        builder: (_, auth, _) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: switch (auth.status) {
            AuthStatus.unknown => const SplashScreen(),
            AuthStatus.authenticated => const FeedScreen(),
            AuthStatus.unauthenticated => const LoginScreen(),
          },
        ),
      ),
    );
  }
}