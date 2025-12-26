import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

class _SplashOverlay extends StatelessWidget {
  const _SplashOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth * 0.7,
              child: Lottie.network(
                'https://lottie.host/a5371b50-8e20-489f-b0a1-6b2cc01b5240/oNrUZte5SJ.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
