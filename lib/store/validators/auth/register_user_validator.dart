import 'package:get/get.dart';

class RegisterUserValidator extends GetxController {
  final RxMap<String, bool> registerUserVerfication = {
    "Email": false,
    "Password": false,
    "Nama": false,
    "No.Telp": false,
  }.obs;

  validatorRegisterUser(String name, String value) {
    if (value.isNotEmpty) {
      switch (name) {
        case "Email":
          if (!value.isEmail) {
            handleVerification(name, false);
            return "Email Tidak Sesuai Format";
          } else {
            handleVerification(name, true);
          }

          break;

        case "Password":
          if (value.length < 8) {
            handleVerification(name, false);
            return "Password Wajib Diisi dan Minimal Terdiri dari 8 Digit";
          } else {
            handleVerification(name, true);
          }

          break;

        case "Nama":
          if (value.isEmpty) {
            handleVerification(name, false);
            return "Nama Wajib Di isi";
          } else {
            handleVerification(name, true);
          }

          break;

        case "No.Telp":
          if (value.length > 14 || value.length < 11) {
            print(true);
            handleVerification(name, false);
            return "Nomer Telpon Wajib Diisi dan Minimal Terdiri dari 11 Digit Sampai 13 Digit";
          } else {
            handleVerification(name, true);
          }
        default:
      }
    }
  }

  void handleVerification(String name, bool value) {
    registerUserVerfication[name] = value;
    registerUserVerfication.refresh();
  }
}
