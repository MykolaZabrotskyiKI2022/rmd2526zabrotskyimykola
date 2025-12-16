import 'package:rmd2526zabrotskyimykola/domain/entities/app_user.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(AppUser user);

  Future<AppUser?> getUser();

  Future<void> clearUser();

  Future<void> setLoggedIn(bool value);

  Future<bool> isLoggedIn();
}

class UserLocalDataSourcePrefs implements UserLocalDataSource {
  static const _keyEmail = 'user_email';
  static const _keyName = 'user_name';
  static const _keyPassword = 'user_password';
  static const _keyLoggedIn = 'user_logged_in';

  @override
  Future<void> saveUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, user.email);
    await prefs.setString(_keyName, user.name);
    await prefs.setString(_keyPassword, user.password);
  }

  @override
  Future<AppUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyEmail);
    final name = prefs.getString(_keyName);
    final password = prefs.getString(_keyPassword);

    if (email == null || name == null || password == null) {
      return null;
    }

    return AppUser(email: email, name: name, password: password);
  }

  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyName);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyLoggedIn);
  }

  @override
  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, value);
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }
}
