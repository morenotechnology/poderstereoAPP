import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_constants.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF05060f), Color(0xFF110c20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            GlassContainer(
              blur: 18,
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFFff6b6b), Color(0xFFf06595)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Familia Poder Stereo', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    const Text('Únete a nuestros canales y mantente cerca del latido espiritual.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ..._links.map(
              (link) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  tileColor: Colors.white.withValues(alpha: 0.05),
                  leading: Icon(link.icon, color: Colors.white),
                  title: Text(link.title),
                  subtitle: Text(link.description),
                  onTap: () => _launch(link.url),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkItem {
  const _LinkItem({required this.icon, required this.title, required this.description, required this.url});

  final IconData icon;
  final String title;
  final String description;
  final String url;
}

const _links = [
  _LinkItem(
    icon: Icons.chat_bubble_outline,
    title: 'WhatsApp',
    description: 'Poder Stereo Comunidad',
    url: AppConstants.whatsappCommunityUrl,
  ),
  _LinkItem(
    icon: Icons.camera_alt_outlined,
    title: 'Instagram',
    description: '@poderstereo',
    url: AppConstants.instagramUrl,
  ),
  _LinkItem(
    icon: Icons.language_rounded,
    title: 'Sitio Web',
    description: AppConstants.websiteUrl,
    url: AppConstants.websiteUrl,
  ),
];

Future<void> _launch(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint('No se pudo abrir $url');
  }
}
