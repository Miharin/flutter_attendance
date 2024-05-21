import 'package:flutter_attendance/store/helper/protected/attendance_helper.dart';
import 'package:flutter_attendance/store/store/protected/attendance_store.dart';
import 'package:get/get.dart';

class AttendanceController extends GetxController {
  final AttendanceStore store = Get.put(AttendanceStore());
  final AttendanceHelper helper = Get.put(AttendanceHelper());
}
