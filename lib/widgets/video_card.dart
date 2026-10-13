import 'package:flutter/material.dart';
import '../models/video.dart';
import '../theme/app_palette.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video, this.onTap});

  final Video video;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;
    final views = video.viewCount == 1 ? '1 view' : '${video.viewCount} views';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder thumbnail until we generate real ones
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [p.primary, p.primaryDark],
                      ),
                    ),
                  ),
                  Center(
                    child: video.isReady
                        ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.play_arrow_rounded, size: 40, color: p.accent),
                    )
                        : const Icon(Icons.hourglass_top_rounded, size: 36, color: Colors.white70),
                  ),
                  if (!video.isReady)
                    Positioned(left: 10, top: 10, child: _Chip(_statusLabel(video.status))),
                  if (video.durationSeconds != null)
                    Positioned(right: 10, bottom: 10, child: _Chip(_formatDuration(video.durationSeconds!))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            video.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(views, style: text.bodySmall?.copyWith(color: p.textMuted)),
        ],
      ),
    );
  }

  static String _statusLabel(String status) => switch (status) {
    'pending_upload' => 'Uploading',
    'processing' => 'Processing',
    'failed' => 'Failed',
    _ => status,
  };

  static String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}