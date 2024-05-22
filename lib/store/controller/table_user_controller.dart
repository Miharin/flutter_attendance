import 'package:flutter_attendance/store/helper/protected/table_user_helper.dart';
import 'package:flutter_attendance/store/store/protected/table_user_store.dart';
import 'package:get/get.dart';

class TableUserController extends GetxController {
  final TableUserStore store = Get.put(TableUserStore());
  final TableUserHelper helper = Get.put(TableUserHelper());
}
