import 'package:flutter_attendance/store/helper/auth/auth_helper.dart';
import 'package:get/get.dart';

class AuthValidator extends GetxController {
  // Verification
  final RxMap<String, bool> authVerification = {
    "email": false,
    "password": false,
  }.obs;

  // Validator TextFormField In Login Screen
  validatorLogin(String name, String value) {
    // If Value is Not Empty Then Next
    if (value.isNotEmpty) {
      // Switch Name
      switch (name) {
        // Email
        case "email":
          // If is Email == false then Set Verification to false and
          // Return to Login Screen to Inform Email Is Not Valid
          if (!value.isEmail) {
            handleVerification(name, false);
            return "Email Tidak Sesuai Format";
          } else {
            // If True then Set Verification to true
            handleVerification(name, true);
          }
          break;
        // Password
        case "password":
          // If length < 8 then Set Verificaition to false and
          // Return to Login Screen to Inform Password Length Must Be 8 or More
          if (value.length < 8) {
            handleVerification(name, false);
            return "Password Wajib Diisi dan Minimal Terdiri dari 8 Digit";
          } else {
            // If True then Set Verification to true
            handleVerification(name, true);
          }
          break;
        default:
      }
    }
  }

  // Handle Verification From Validator Login
  void handleVerification(String name, bool value) {
    authVerification[name] = value;
    authVerification.refresh();
    final AuthHelper helper = Get.put(AuthHelper());
    helper.handleSignInButton(authVerification);
  }
}
