class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final userData = map['user'] ?? map; 
    
    return UserModel(
      id: userData['id'] as int,
      name: userData['username'] as String,
      email: userData['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': name,
    'email': email,
  };
}
