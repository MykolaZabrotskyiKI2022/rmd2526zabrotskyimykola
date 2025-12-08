class AppUser {
  const AppUser({
    required this.email,
    required this.name,
    required this.password,
  });

  final String email;
  final String name;
  final String password;

  AppUser copyWith({String? email, String? name, String? password}) {
    return AppUser(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
    );
  }
}
