class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final dynamic userData = map['user'] ?? map;

    return UserModel(
      id: userData['id'] as int,

      name: (userData['username'] ?? userData['name'] ?? 'Unknown User')
          .toString(),

      email: (userData['email'] ?? 'No Email').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'username': name, 'email': email};
}
