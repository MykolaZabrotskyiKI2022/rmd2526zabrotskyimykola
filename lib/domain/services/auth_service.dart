import 'package:rmd2526zabrotskyimykola/domain/entities/app_user.dart';
import 'package:rmd2526zabrotskyimykola/domain/repositories/user_repository.dart';

class AuthService {
  const AuthService(this._repository);

  final UserRepository _repository;

  Future<String?> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final error = _validateRegistration(
      email: email,
      name: name,
      password: password,
    );

    if (error != null) {
      return error;
    }

    final user = AppUser(
      email: email.trim(),
      name: name.trim(),
      password: password,
    );

    await _repository.saveUser(user);
    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final savedUser = await _repository.loadUser();

    if (savedUser == null) {
      return 'User is not registered yet';
    }

    if (savedUser.email.trim() != email.trim()) {
      return 'Email does not match';
    }

    if (savedUser.password != password) {
      return 'Incorrect password';
    }

    return null;
  }

  Future<AppUser?> getCurrentUser() {
    return _repository.loadUser();
  }

  Future<void> updateUser(AppUser user) {
    return _repository.saveUser(user);
  }

  Future<void> deleteUser() {
    return _repository.deleteUser();
  }

  String? _validateRegistration({
    required String email,
    required String name,
    required String password,
  }) {
    if (!email.contains('@')) {
      return 'Email must contain @';
    }

    if (name.trim().isEmpty) {
      return 'Name must not be empty';
    }

    if (RegExp(r'\d').hasMatch(name)) {
      return 'Name must not contain digits';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }
}
