import '../../models/user.dart';
import 'database_helper.dart';

class UserDao {
  final DatabaseHelper _dbHelper = DatabaseHelperFactory.create();

  Future<AppUser?> findByEmail(String email) async {
    return await _dbHelper.findUserByEmail(email);
  }

  Future<AppUser?> findById(int id) async {
    return await _dbHelper.findUserById(id);
  }

  Future<int> insert(Map<String, Object?> data) async {
    return await _dbHelper.insertUser(data);
  }
}
