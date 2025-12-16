import 'package:rmd2526zabrotskyimykola/data/datasources/user_local_data_source.dart';
import 'package:rmd2526zabrotskyimykola/domain/entities/app_user.dart';
import 'package:rmd2526zabrotskyimykola/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._local);

  final UserLocalDataSource _local;

  @override
  Future<void> saveUser(AppUser user) {
    return _local.saveUser(user);
  }

  @override
  Future<AppUser?> loadUser() {
    return _local.getUser();
  }

  @override
  Future<void> deleteUser() {
    return _local.clearUser();
  }
}
