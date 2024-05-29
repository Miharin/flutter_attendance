import 'package:flutter_attendance/store/helper/protected/table_user_helper.dart';
import 'package:get/get.dart';

class RegisterUserValidator extends GetxController {
  final RxMap<String, bool> registerUserVerfication = {
    "Email": false,
    "Password": false,
    "Nama": false,
    "No.Telp": false,
  }.obs;

  validatorRegisterUSer(String name, String value) {
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
          if (value.length > 14 && value.length < 11) {
            handleVerification(name, false);
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
    final TableUserHelper helper = Get.put(TableUserHelper());
    helper.handleSubmitAddDataContent();
  }
}
