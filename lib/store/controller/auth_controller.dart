import 'package:flutter_attendance/store/helper/auth/auth_helper.dart';
import 'package:flutter_attendance/store/store/auth/auth_store.dart';
import 'package:flutter_attendance/store/validators/auth/auth_validator.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthHelper helper = Get.put(AuthHelper());
  final AuthStore store = Get.put(AuthStore());
  final AuthValidator validator = Get.put(AuthValidator());
}
