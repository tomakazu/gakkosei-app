import 'dart:io' show Platform;

class AppConfig {
  // Android emulator reaches your Mac via 10.0.2.2; iOS simulator can use localhost.
  static String get apiBaseUrl => Platform.isAndroid
      ? 'http://10.0.2.2:3000/api/v1'
      : 'http://localhost:3000/api/v1';

  /// DEV ONLY. Our videos can't play until CloudFront is set up,
  /// so while this is set, every video plays this public test stream.
  /// Set it to null once CloudFront works.
  static const String? devStreamOverride =
      'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';
}