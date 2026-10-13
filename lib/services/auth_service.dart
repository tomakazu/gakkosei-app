import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'api_client.dart';

/// unknown = still checking on startup (show splash)
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthService extends ChangeNotifier {
  AuthService(this._api);

  final ApiClient _api;
  User? _currentUser;
  AuthStatus _status = AuthStatus.unknown;

  User? get currentUser => _currentUser;
  AuthStatus get status => _status;
  bool get isLoggedIn => _status == AuthStatus.authenticated;

  /// Called once by the splash screen. Waits at least [minimumDelay]
  /// so the splash animation isn't cut short.
  Future<void> restoreSession({Duration minimumDelay = Duration.zero}) async {
    final results = await Future.wait([
      _lookupSavedUser(),
      Future.delayed(minimumDelay),
    ]);
    _setUser(results.first as User?);
  }

  Future<User?> _lookupSavedUser() async {
    final token = await _api.readToken();
    if (token == null) return null;
    try {
      final data = await _api.get('/me');
      return User.fromJson(data['user'] as Map<String, dynamic>);
    } on ApiException catch (e) {
      // 401 = token expired or invalid: forget it
      if (e.statusCode == 401) await _api.clearToken();
      return null;
    } catch (_) {
      // Server unreachable: show login, but keep the token for next time
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    final data = await _api.post('/login', {'email': email, 'password': password});
    await _storeSession(data);
  }

  Future<void> signup(String email, String username, String password) async {
    final data = await _api.post('/signup',
        {'email': email, 'username': username, 'password': password});
    await _storeSession(data);
  }

  Future<void> logout() async {
    await _api.clearToken();
    _setUser(null);
  }

  Future<void> _storeSession(dynamic data) async {
    await _api.saveToken(data['token'] as String);
    _setUser(User.fromJson(data['user'] as Map<String, dynamic>));
  }

  void _setUser(User? user) {
    _currentUser = user;
    _status = user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    notifyListeners();
  }
}