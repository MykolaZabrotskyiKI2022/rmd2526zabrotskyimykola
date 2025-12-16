import 'package:rmd2526zabrotskyimykola/data/datasources/user_local_data_source.dart';
import 'package:rmd2526zabrotskyimykola/data/repositories/user_repository_impl.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/auth_service.dart';

final AuthService authService = AuthService(
  UserRepositoryImpl(UserLocalDataSourcePrefs()),
);
