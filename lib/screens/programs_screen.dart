import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF08060f), Color(0xFF140d22)],
        ),
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: _programs.length,
          itemBuilder: (context, index) {
            final item = _programs[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: GlassContainer(
                blur: 20,
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1d1b2f), Color(0xFF272545)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text(item.description, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded, color: Colors.white60),
                          const SizedBox(width: 8),
                          Text(item.time, style: theme.textTheme.labelLarge),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProgramInfo {
  const _ProgramInfo({required this.title, required this.description, required this.time});

  final String title;
  final String description;
  final String time;
}

const _programs = [
  _ProgramInfo(
    title: 'Amanecer de Gracia',
    description: 'Devocionales, oración y palabra para iniciar el día.',
    time: '05:00 AM - 07:00 AM',
  ),
  _ProgramInfo(
    title: 'Fuego en Vivo',
    description: 'Entrevistas, música urbana y testimonios.',
    time: '12:00 PM - 02:00 PM',
  ),
  _ProgramInfo(
    title: 'Voces Proféticas',
    description: 'Palabra rema y consejería profética cada noche.',
    time: '07:00 PM - 09:00 PM',
  ),
  _ProgramInfo(
    title: 'Noches de intimidad',
    description: 'Sesiones acústicas y momentos íntimos de adoración.',
    time: '10:00 PM - 12:00 AM',
  ),
];
