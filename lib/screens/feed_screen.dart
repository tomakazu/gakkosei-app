import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/video.dart';
import '../services/auth_service.dart';
import '../services/video_service.dart';
import '../theme/app_palette.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/gakkosei_logo.dart';
import '../widgets/video_card.dart';
import 'player_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<Video>> _videos;

  @override
  void initState() {
    super.initState();
    _videos = context.read<VideoService>().fetchFeed();
  }

  Future<void> _refresh() async {
    final next = context.read<VideoService>().fetchFeed();
    setState(() => _videos = next);
    try {
      await next;
    } catch (_) {
      // The error is shown by the FutureBuilder below
    }
  }

  void _open(Video video) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlayerScreen(video: video)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final auth = context.read<AuthService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GakkoseiLogo(size: 32),
            SizedBox(width: 10),
            GakkoseiWordmark(fontSize: 22),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: auth.logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: p.primary,
        onRefresh: _refresh,
        child: FutureBuilder<List<Video>>(
          future: _videos,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _MessageView(
                icon: Icons.wifi_off_rounded,
                title: "Couldn't load videos",
                message: friendlyError(snapshot.error!),
                actionLabel: 'Try again',
                onAction: _refresh,
              );
            }
            final videos = snapshot.data!;
            if (videos.isEmpty) {
              return const _MessageView(
                icon: Icons.video_library_outlined,
                title: 'No videos yet',
                message: 'Public videos will show up here once they are uploaded.',
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: videos.length,
              separatorBuilder: (_, _) => const SizedBox(height: 24),
              itemBuilder: (_, i) {
                final video = videos[i];
                return VideoCard(
                  video: video,
                  onTap: video.isReady ? () => _open(video) : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Empty and error states. Scrollable so pull-to-refresh still works.
class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 120),
      children: [
        Icon(icon, size: 56, color: p.textMuted),
        const SizedBox(height: 16),
        Text(title,
            textAlign: TextAlign.center,
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(message,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: p.textMuted)),
        if (actionLabel != null) ...[
          const SizedBox(height: 24),
          Center(child: FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!))),
        ],
      ],
    );
  }
}