class Video {
  final int id;
  final String title;
  final String? description;
  final String status;
  final int? durationSeconds;
  final String? manifestUrl;
  final int viewCount;

  Video({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.durationSeconds,
    this.manifestUrl,
    required this.viewCount,
  });

  bool get isReady => status == 'ready' && manifestUrl != null;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String?,
    status: json['status'] as String,
    durationSeconds: json['duration_seconds'] as int?,
    manifestUrl: json['manifest_url'] as String?,
    // view_count has no default in your Rails migration, so it can be null
    viewCount: (json['view_count'] as int?) ?? 0,
  );
}