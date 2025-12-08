import 'package:rmd2526zabrotskyimykola/domain/entities/app_user.dart';

abstract class UserRepository {
  Future<void> saveUser(AppUser user);

  Future<AppUser?> loadUser();

  Future<void> deleteUser();
}
