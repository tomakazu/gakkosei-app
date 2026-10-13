import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../config.dart';
import '../models/video.dart';
import '../theme/app_palette.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.video});
  final Video video;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _setUpPlayer();
  }

  Future<void> _setUpPlayer() async {
    final url = AppConfig.devStreamOverride ?? widget.video.manifestUrl!;
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      // Downloads the .m3u8 map and the first pieces, and learns the video's size
      await controller.initialize();
    } catch (_) {
      await controller.dispose();
      if (mounted) setState(() => _error = "This video couldn't be played.");
      return;
    }

    if (!mounted) {
      await controller.dispose();
      return;
    }

    final p = AppPalette.of(context);
    final colors = ChewieProgressColors(
      playedColor: p.accent,
      handleColor: p.accent,
      bufferedColor: Colors.white38,
      backgroundColor: Colors.white12,
    );

    setState(() {
      _videoController = controller;
      _chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        aspectRatio: controller.value.aspectRatio,
        materialProgressColors: colors,
        cupertinoProgressColors: colors,
      );
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final text = Theme.of(context).textTheme;
    final video = widget.video;
    final views = video.viewCount == 1 ? '1 view' : '${video.viewCount} views';

    return Scaffold(
      appBar: AppBar(title: Text(video.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: _videoController?.value.aspectRatio ?? 16 / 9,
            child: ColoredBox(
              color: Colors.black,
              child: _error != null
                  ? Center(child: Text(_error!, style: const TextStyle(color: Colors.white70)))
                  : _chewieController == null
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : Chewie(controller: _chewieController!),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(video.title,
                    style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(views, style: text.bodyMedium?.copyWith(color: p.textMuted)),
                if (video.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 16),
                  Text(video.description!, style: text.bodyMedium),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}