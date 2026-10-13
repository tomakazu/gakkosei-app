import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_palette.dart';
import '../widgets/gakkosei_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final Animation<double> _fade =
  CurvedAnimation(parent: _controller, curve: Curves.easeOut);

  late final Animation<double> _scale = Tween(begin: 0.8, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
  );

  @override
  void initState() {
    super.initState();
    // Check for a saved login while the animation plays
    context.read<AuthService>().restoreSession(
      minimumDelay: const Duration(milliseconds: 1600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [p.primaryDark, p.primary],
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(scale: _scale, child: const GakkoseiLogo(size: 112)),
              const SizedBox(height: 20),
              const GakkoseiWordmark(color: Colors.white, fontSize: 36),
              const SizedBox(height: 8),
              Text(
                'Learn anything, one video at a time',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}