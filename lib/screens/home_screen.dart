import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_constants.dart';
import '../providers/blog_provider.dart';
import '../providers/radio_player_provider.dart';
import '../providers/verse_provider.dart';
import '../services/blog_service.dart';
import '../services/verse_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final radio = context.watch<RadioPlayerProvider>();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF19041F), Color(0xFF2A0D39)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            children: [
              const _Header(),
              const SizedBox(height: 26),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _WaveHero(
                      isPlaying: radio.isPlaying,
                      error: radio.errorMessage,
                      level: radio.level,
                    ),
                    const SizedBox(height: 20),
                    const _BlogSlider(),
                    const SizedBox(height: 20),
                    const _VerseOfDayCard(),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
              _BottomDock(radio: radio),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 90,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/logo_stereo.png',
              fit: BoxFit.contain,
              height: 90,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'La radio que te conecta al cielo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                'Conexión en vivo 24/7',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WaveHero extends StatefulWidget {
  const _WaveHero({required this.isPlaying, required this.error, required this.level});

  final bool isPlaying;
  final String? error;
  final double level;

  @override
  State<_WaveHero> createState() => _WaveHeroState();
}

class _WaveHeroState extends State<_WaveHero> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amplitudeFactor = widget.isPlaying ? (0.2 + widget.level.clamp(0, 1) * 0.8) : 0.2;
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Container(
        height: 280,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF120726), Color(0xFF311146)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _WavePainter(
                      phase: _controller.value * 2 * pi,
                      amplitudeFactor: amplitudeFactor,
                    ),
                  ),
                ),
                Positioned(
                  top: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/hero.png',
                      width: 260,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 26,
                  right: 26,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.radio_rounded, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            widget.isPlaying ? 'Transmitiendo ahora' : 'Listo para reproducir',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      if (widget.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            widget.error!,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


class _BlogSlider extends StatefulWidget {
  const _BlogSlider();

  @override
  State<_BlogSlider> createState() => _BlogSliderState();
}

class _BlogSliderState extends State<_BlogSlider> {
  late final PageController _controller = PageController(viewportFraction: 0.78);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blogState = context.watch<BlogProvider>();

    return SizedBox(
      height: 168,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (blogState.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (blogState.error != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(blogState.error!, style: const TextStyle(color: Colors.white70)),
                TextButton(onPressed: blogState.loadPosts, child: const Text('Reintentar')),
              ],
            );
          }

          if (blogState.posts.isEmpty) {
            return const Center(
              child: Text('No hay publicaciones aún.', style: TextStyle(color: Colors.white70)),
            );
          }

          final cardWidth = constraints.maxWidth * 0.78;
          return PageView.builder(
            controller: _controller,
            padEnds: false,
            itemCount: blogState.posts.length,
            itemBuilder: (context, index) {
              final post = blogState.posts[index];
              return Padding(
                padding: EdgeInsets.only(right: index == blogState.posts.length - 1 ? 0 : 14),
                child: SizedBox(width: cardWidth, child: _BlogCard(post: post)),
              );
            },
          );
        },
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  const _BlogCard({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    final summary = post.summary.isNotEmpty
        ? (post.summary.length > 100 ? '${post.summary.substring(0, 100)}…' : post.summary)
        : 'Pronto compartiremos más detalles.';
    final destination = Uri.parse('https://poderstereolivetv.com/${post.slug}');

    return GestureDetector(
      onTap: () => launchUrl(destination, mode: LaunchMode.externalApplication),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2C0F4D), Color(0xFF81277D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              if (post.imageUrl != null)
                Positioned.fill(
                  child: Image.network(
                    post.imageUrl!,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.multiply,
                    color: Colors.black.withOpacity(0.45),
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      summary,
                      style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerseOfDayCard extends StatelessWidget {
  const _VerseOfDayCard();

  @override
  Widget build(BuildContext context) {
    final verseState = context.watch<VerseProvider>();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/biblia.jpg',
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.multiply,
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Versículo del día',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                const SizedBox(height: 12),
                if (verseState.isLoading)
                  const Center(
                    child: SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                else if (verseState.error != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          verseState.error!,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: Colors.white),
                        onPressed: verseState.loadVerse,
                        child: const Text('Reintentar'),
                      )
                    ],
                  )
                else if (verseState.verse != null)
                  _VerseContent(verse: verseState.verse!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerseContent extends StatelessWidget {
  const _VerseContent({required this.verse});

  final BibleVerse verse;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          verse.reference,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => _showVerseDialog(context, verse),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            backgroundColor: Colors.white.withOpacity(0.12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: const Text('Tu versículo del día'),
        ),
      ],
    );
  }
}

Future<void> _showVerseDialog(BuildContext context, BibleVerse verse) {
  return showGeneralDialog(
    context: context,
    barrierLabel: 'Cerrar',
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.6),
    pageBuilder: (context, _, __) {
      return Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1028).withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Versículo completo',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      verse.reference,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      verse.text,
                      style: const TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _BottomDock extends StatelessWidget {
  const _BottomDock({required this.radio});

  final RadioPlayerProvider radio;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(46),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.14),
                Colors.white.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(46),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _DockIcon(icon: FontAwesomeIcons.globe, onTap: () => _launch(AppConstants.websiteUrl)),
              _DockIcon(icon: FontAwesomeIcons.whatsapp, onTap: () => _launch(AppConstants.whatsappCommunityUrl)),
              GestureDetector(
                onTap: radio.togglePlayback,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF5F6D), Color(0xFFF7B42C), Color(0xFF7F00FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Center(
                    child: radio.isBuffering
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4),
                          )
                        : Icon(
                            radio.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                  ),
                ),
              ),
              _DockIcon(icon: FontAwesomeIcons.instagram, onTap: () => _launch(AppConstants.instagramUrl)),
              _DockIcon(icon: FontAwesomeIcons.envelope, onTap: () => _launch('mailto:${AppConstants.contactEmail}')),
            ],
          ),
        ),
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  const _DockIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 21),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter({required this.phase, required this.amplitudeFactor});

  final double phase;
  final double amplitudeFactor;

  static const _layers = [
    _WaveLayer(color: Color(0xFFFF5050), amplitude: 68, depth: 0.9, strokeWidth: 2.3),
    _WaveLayer(color: Color(0xFFFFA03C), amplitude: 54, depth: 0.75, strokeWidth: 1.9),
    _WaveLayer(color: Color(0xFFB450FF), amplitude: 44, depth: 0.65, strokeWidth: 1.6),
    _WaveLayer(color: Color(0xFF50A0FF), amplitude: 34, depth: 0.5, strokeWidth: 1.3),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height * 0.55;
    const points = 160;
    final step = size.width / points;

    for (final layer in _layers) {
      final amplitude = layer.amplitude * amplitudeFactor;
      final path = Path();

      for (int i = 0; i <= points; i++) {
        final x = i * step;
        final wave = sin(i * 0.15 + phase);
        final depth = sin(i * 0.05 - phase * 0.6);
        final y = centerY + wave * amplitude + depth * amplitude * layer.depth;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = layer.strokeWidth
        ..color = layer.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

      canvas.drawPath(path, linePaint);

      // Mesh style verticals to give the wave depth.
      final meshPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = layer.color.withOpacity(0.25);

      for (int i = 0; i <= points; i += 4) {
        final x = i * step;
        final offset = sin(i * 0.2 + phase) * amplitude;
        final meshPath = Path()
          ..moveTo(x, centerY - offset * 0.6)
          ..lineTo(x, centerY + offset * 0.6);
        canvas.drawPath(meshPath, meshPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.phase != phase || oldDelegate.amplitudeFactor != amplitudeFactor;
  }
}

class _WaveLayer {
  const _WaveLayer({
    required this.color,
    required this.amplitude,
    required this.depth,
    required this.strokeWidth,
  });

  final Color color;
  final double amplitude;
  final double depth;
  final double strokeWidth;
}

Future<void> _launch(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint('No se pudo abrir $url');
  }
}
