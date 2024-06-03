import 'package:intl/intl.dart';

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
    required this.statusLate,
  });
  final String name;
  final String dateTime;
  final double latitude;
  final double longitude;
  final String status;
  final String statusOutside;
  final String type;
  final String workplaceID;
  final String alasan;
  final String statusLate;

  factory UserHistoryModel.fromJson(
          Map<String, dynamic> userHistoryJSON, String name) =>
      UserHistoryModel(
        name: name,
        dateTime: DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(DateTime.parse(userHistoryJSON["datetime"])),
        latitude: double.parse(userHistoryJSON["latitude"]),
        longitude: double.parse(userHistoryJSON["longitude"]),
        status: userHistoryJSON["status"],
        statusOutside: userHistoryJSON["status_outside"] ?? "",
        type: userHistoryJSON["type"],
        workplaceID: userHistoryJSON["workplace_id"],
        alasan: userHistoryJSON["alasan"] ?? "",
        statusLate: userHistoryJSON["statusLate"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "dateTime": dateTime,
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
        "status": status,
        "statusOutside": statusOutside,
        "type": type,
        "workplaceID": workplaceID,
        "alasan": alasan,
      };
}
