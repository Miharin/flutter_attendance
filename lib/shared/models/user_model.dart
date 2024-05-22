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

class UserHistoryModel {
  UserHistoryModel({
    required this.name,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.statusOutside,
    required this.type,
    required this.workplaceID,
    required this.alasan,
  });
  final String name;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final String status;
  final String statusOutside;
  final String type;
  final String workplaceID;
  final String alasan;

  factory UserHistoryModel.fromJson(
          Map<String, dynamic> userHistoryJSON, String name) =>
      UserHistoryModel(
        name: name,
        dateTime: DateTime.parse(userHistoryJSON["DateTime"]),
        latitude: double.parse(userHistoryJSON["latitude"]),
        longitude: double.parse(userHistoryJSON["longitude"]),
        status: userHistoryJSON["status"],
        statusOutside: userHistoryJSON["statusOutside"],
        type: userHistoryJSON["type"],
        workplaceID: userHistoryJSON["workplaceId"],
        alasan: userHistoryJSON["alasan"],
      );
}
