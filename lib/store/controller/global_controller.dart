import 'package:flutter_attendance/store/controller/attendance_controller.dart';
import 'package:flutter_attendance/store/controller/auth_controller.dart';
import 'package:flutter_attendance/store/controller/table_place_controller.dart';
import 'package:flutter_attendance/store/controller/table_user_controller.dart';
import 'package:flutter_attendance/store/helper/protected/drawer.helper.dart';
import 'package:flutter_attendance/store/helper/protected/table_user_helper.dart';
import 'package:get/get.dart';

class GlobalController implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => AttendanceController());
    Get.lazyPut(() => TablePlaceController());
    Get.lazyPut(() => TableUserHelper());
    Get.lazyPut(() => CustomDrawerController());
    Get.lazyPut(() => TableUserController());
  }
}
