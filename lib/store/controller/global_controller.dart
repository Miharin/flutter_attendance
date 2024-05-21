import 'package:flutter_attendance/store/controller/attendance_controller.dart';
import 'package:flutter_attendance/store/controller/auth_controller.dart';
import 'package:flutter_attendance/store/helper/protected/drawer.helper.dart';
import 'package:get/get.dart';

class GlobalController implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => AttendanceController());
    Get.lazyPut(() => CustomDrawerController());
  }
}
