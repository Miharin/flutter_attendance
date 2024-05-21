class UserModel {
  UserModel({
    required this.email,
    required this.name,
    required this.password,
    required this.role,
    required this.number,
  });

  final String email;
  final String name;
  final String password;
  final String role;
  final String number;

  factory UserModel.fromJSON(Map<String, dynamic> authJSON) => UserModel(
        email: authJSON["email"],
        name: authJSON["name"],
        password: authJSON["password"],
        role: authJSON["role"],
        number: authJSON["telp_number"],
      );
}
