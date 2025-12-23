import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_constants.dart';
import '../providers/radio_player_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/live_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final radio = context.watch<RadioPlayerProvider>();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF05020a), Color(0xFF10081c), Color(0xFF1b1030)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(theme: theme),
              const SizedBox(height: 24),
              _FilterChips(),
              const SizedBox(height: 24),
              _FeaturedCard(size: size, isPlaying: radio.isPlaying),
              const SizedBox(height: 20),
              if (radio.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    radio.errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              Text('Programación destacada', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              ..._topShows.map(
                (show) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1c1b2b), Color(0xFF29283a)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            image: DecorationImage(
                              image: AssetImage(show.cover),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(show.title, style: theme.textTheme.titleMedium),
                              Text(
                                show.subtitle,
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const LiveIndicator(),
                            const SizedBox(height: 6),
                            Text(show.time, style: theme.textTheme.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Explora la familia Poder Stereo', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _socialLinks
                    .map(
                      (link) => _SocialCard(
                        icon: link.icon,
                        title: link.title,
                        description: link.description,
                        onTap: () => _launch(link.url),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: const AssetImage('assets/images/guest.jpg'),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hola, familia', style: theme.textTheme.titleMedium),
              Text(
                'Poder Stereo',
                style: theme.textTheme.displaySmall?.copyWith(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.favorite_outline_rounded),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  static const List<String> _chips = ['Todo', 'Adoración', 'Podcast', 'En vivo'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, _) => const SizedBox(width: 12),
        itemCount: _chips.length,
        itemBuilder: (context, index) {
          final selected = index == 0;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFdbff6c) : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                _chips[index],
                style: TextStyle(
                  color: selected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.size, required this.isPlaying});

  final Size size;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3121ff), Color(0xFFb5179e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('En vivo ahora', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 6),
            Text(
              'Alabanza continua',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Conecta con la presencia de Dios 24/7 desde cualquier lugar.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const LiveIndicator(),
                const SizedBox(width: 12),
                Text(isPlaying ? 'Transmitiendo' : 'Listo para reproducir'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialCard extends StatelessWidget {
  const _SocialCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        width: MediaQuery.of(context).size.width * 0.42,
        blur: 16,
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 4),
              Text(description, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowInfo {
  const _ShowInfo({required this.title, required this.subtitle, required this.cover, required this.time});

  final String title;
  final String subtitle;
  final String cover;
  final String time;
}

const _topShows = [
  _ShowInfo(
    title: 'Amanecer de Gracia',
    subtitle: 'Con Ps. Daniela Vélez',
    cover: 'assets/images/guest.jpg',
    time: '05:00 AM',
  ),
  _ShowInfo(
    title: 'Fuego en Vivo',
    subtitle: 'Luces de Poder Stereo',
    cover: 'assets/images/guest.jpg',
    time: '12:00 PM',
  ),
  _ShowInfo(
    title: 'Noches de intimidad',
    subtitle: 'Sábados especiales',
    cover: 'assets/images/guest.jpg',
    time: '09:00 PM',
  ),
];

class _SocialLink {
  const _SocialLink({required this.icon, required this.title, required this.description, required this.url});

  final IconData icon;
  final String title;
  final String description;
  final String url;
}

const _socialLinks = [
  _SocialLink(
    icon: Icons.language_rounded,
    title: 'Sitio Oficial',
    description: AppConstants.websiteUrl,
    url: AppConstants.websiteUrl,
  ),
  _SocialLink(
    icon: Icons.chat_bubble_outline,
    title: 'WhatsApp',
    description: 'Únete a la comunidad',
    url: AppConstants.whatsappCommunityUrl,
  ),
  _SocialLink(
    icon: Icons.camera_alt_outlined,
    title: 'Instagram',
    description: '@poderstereo',
    url: AppConstants.instagramUrl,
  ),
  _SocialLink(
    icon: Icons.mail_outline_rounded,
    title: 'Email',
    description: AppConstants.contactEmail,
    url: 'mailto:${AppConstants.contactEmail}',
  ),
];

Future<void> _launch(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint('No se pudo abrir $url');
  }
}
