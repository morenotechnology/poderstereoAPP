import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/radio_player_provider.dart';
import 'screens/community_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/home_screen.dart';
import 'screens/programs_screen.dart';
import 'services/radio_player_service.dart';
import 'widgets/play_toggle.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RadioPlayerProvider(RadioPlayerService()),
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
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    ProgramsScreen(),
    CommunityScreen(),
    ContactScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final radio = context.watch<RadioPlayerProvider>();
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _pages[_index],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavIcon(
                    icon: Icons.home_rounded,
                    isSelected: _index == 0,
                    onTap: () => setState(() => _index = 0),
                  ),
                  _NavIcon(
                    icon: Icons.library_music_rounded,
                    isSelected: _index == 1,
                    onTap: () => setState(() => _index = 1),
                  ),
                  PlayToggle(
                    size: 72,
                    isPlaying: radio.isPlaying,
                    isLoading: radio.isBuffering,
                    onTap: radio.togglePlayback,
                  ),
                  _NavIcon(
                    icon: Icons.groups_rounded,
                    isSelected: _index == 2,
                    onTap: () => setState(() => _index = 2),
                  ),
                  _NavIcon(
                    icon: Icons.support_agent_rounded,
                    isSelected: _index == 3,
                    onTap: () => setState(() => _index = 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon, required this.isSelected, required this.onTap});

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : Colors.white54;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
