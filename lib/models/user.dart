class UserModel {
  final String name;
  final String email;
  final String password;

  const UserModel({
    required this.name,
    required this.email,
    required this.password
  });

  Map<String, String> toMap() => {
      'name': name,
      'email': email,
      'password': password
  };
}
