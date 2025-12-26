import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/blog_provider.dart';
import 'providers/radio_player_provider.dart';
import 'providers/verse_provider.dart';
import 'screens/home_screen.dart';
import 'services/blog_service.dart';
import 'services/radio_player_service.dart';
import 'services/verse_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RadioPlayerProvider(RadioPlayerService()),
        ),
        ChangeNotifierProvider(
          create: (_) => VerseProvider(VerseService()),
        ),
        ChangeNotifierProvider(
          create: (_) => BlogProvider(BlogService()),
        ),
      ],
      child: const PoderStereoApp(),
    ),
  );
}

class PoderStereoApp extends StatelessWidget {
  const PoderStereoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poder Stereo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepare();
    });
  }

  Future<void> _prepare() async {
    final blog = context.read<BlogProvider>();
    final verse = context.read<VerseProvider>();
    final radio = context.read<RadioPlayerProvider>();
    await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      blog.ready,
      verse.ready,
      radio.ready,
    ]);
    if (!mounted) return;
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const HomeScreen(),
          if (_showSplash) const _SplashOverlay(),
        ],
      ),
    );
  }
}

class _SplashOverlay extends StatefulWidget {
  const _SplashOverlay();

  @override
  State<_SplashOverlay> createState() => _SplashOverlayState();
}

class _SplashOverlayState extends State<_SplashOverlay>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _logoController;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    // Gradient animation - cycles through colors
    _gradientController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    // Logo pulse animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  const Color(0xFF19041F),
                  const Color(0xFF2A0D39),
                  _gradientController.value,
                )!,
                Color.lerp(
                  const Color(0xFF2A0D39),
                  const Color(0xFF6B0F1A),
                  _gradientController.value,
                )!,
                Color.lerp(
                  const Color(0xFF1A0A2E),
                  const Color(0xFF4A0E4E),
                  _gradientController.value,
                )!,
              ],
            ),
          ),
          child: Center(
            child: ScaleTransition(
              scale: _logoScale,
              child: Image.asset(
                'assets/images/logo_stereo.png',
                width: 220,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
