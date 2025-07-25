import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SharedPrefsStorage extends LocalStorage {
  static const _sessionKey = 'supabase_session';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  @override
  Future<String?> accessToken() async {
    final prefs = await _prefs;
    return prefs.getString(_sessionKey);
  }

  @override
  Future<bool> hasAccessToken() async {
    final prefs = await _prefs;
    return prefs.containsKey(_sessionKey);
  }

  @override
  Future<void> initialize() async {
    // No need to store empty session on init
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    final prefs = await _prefs;
    await prefs.setString(_sessionKey, persistSessionString);
  }

  @override
  Future<void> removePersistedSession() async {
    final prefs = await _prefs;
    await prefs.remove(_sessionKey);
  }
}
