import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/hashing.dart';
import '../data/local/user_dao.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final _dao = UserDao();
  final _storage = const FlutterSecureStorage();

  AppUser? _current;
  AppUser? get current => _current;

  bool _loading = true;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  AuthProvider() {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      final idStr = await _storage.read(key: 'uid');
      if (idStr != null) {
        final u = await _dao.findById(int.parse(idStr));
        _current = u;
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password) async {
    _error = null;
    try {
      final existing = await _dao.findByEmail(email.trim());
      if (existing != null) {
        _error = 'Email sudah terdaftar';
        notifyListeners();
        return false;
      }
      final salt = generateSalt();
      final hash = hashPassword(password, salt);
      final id = await _dao.insert({
        'email': email.trim(),
        'password_hash': hash,
        'salt': salt,
        'created_at': DateTime.now().toIso8601String(),
      });
      final user = await _dao.findById(id);
      _current = user;
      await _storage.write(key: 'uid', value: user!.id.toString());
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Gagal register: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _error = null;
    try {
      final user = await _dao.findByEmail(email.trim());
      if (user == null) {
        _error = 'Email tidak ditemukan';
        notifyListeners();
        return false;
      }
      final hash = hashPassword(password, user.salt);
      if (hash != user.passwordHash) {
        _error = 'Password salah';
        notifyListeners();
        return false;
      }
      _current = user;
      await _storage.write(key: 'uid', value: user.id.toString());
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Gagal login: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _current = null;
    await _storage.delete(key: 'uid');
    notifyListeners();
  }
}
