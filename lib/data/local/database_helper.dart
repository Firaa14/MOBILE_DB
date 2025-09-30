import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import 'dart:convert';

// Interface untuk database operations
abstract class DatabaseHelper {
  Future<AppUser?> findUserByEmail(String email);
  Future<AppUser?> findUserById(int id);
  Future<int> insertUser(Map<String, Object?> data);
}

// Implementation untuk web menggunakan SharedPreferences
class WebDatabaseHelper implements DatabaseHelper {
  static const String _usersKey = 'users';
  static const String _idCounterKey = 'user_id_counter';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  @override
  Future<AppUser?> findUserByEmail(String email) async {
    final prefs = await _prefs;
    final usersJson = prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> usersList = json.decode(usersJson);

    for (final userMap in usersList) {
      if (userMap['email'] == email) {
        return AppUser.fromMap(Map<String, dynamic>.from(userMap));
      }
    }
    return null;
  }

  @override
  Future<AppUser?> findUserById(int id) async {
    final prefs = await _prefs;
    final usersJson = prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> usersList = json.decode(usersJson);

    for (final userMap in usersList) {
      if (userMap['id'] == id) {
        return AppUser.fromMap(Map<String, dynamic>.from(userMap));
      }
    }
    return null;
  }

  @override
  Future<int> insertUser(Map<String, Object?> data) async {
    final prefs = await _prefs;
    final usersJson = prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> usersList = json.decode(usersJson);

    // Generate new ID
    final currentId = prefs.getInt(_idCounterKey) ?? 0;
    final newId = currentId + 1;
    await prefs.setInt(_idCounterKey, newId);

    // Add new user
    final userData = Map<String, dynamic>.from(data);
    userData['id'] = newId;
    usersList.add(userData);

    // Save back to preferences
    await prefs.setString(_usersKey, json.encode(usersList));

    return newId;
  }
}

// Factory untuk membuat database helper yang sesuai dengan platform
class DatabaseHelperFactory {
  static DatabaseHelper create() {
    if (kIsWeb) {
      return WebDatabaseHelper();
    } else {
      // Untuk mobile/desktop, kita masih bisa mencoba menggunakan SQLite
      // Tapi untuk sementara, gunakan WebDatabaseHelper untuk semua platform
      return WebDatabaseHelper();
    }
  }
}
