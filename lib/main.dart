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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeScreen(),
    );
  }
}
