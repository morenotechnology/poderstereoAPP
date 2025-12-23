import 'package:flutter/material.dart';

class PlayToggle extends StatelessWidget {
  const PlayToggle({
    super.key,
    required this.isPlaying,
    required this.isLoading,
    required this.onTap,
    this.size = 72,
  });

  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isPlaying
                ? const [Color(0xFFff6b6b), Color(0xFFf06595)]
                : const [Color(0xFF34d1bf), Color(0xFF2f8ffd)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: size * 0.45,
                ),
        ),
      ),
    );
  }
}
