import 'package:flutter_attendance/store/helper/protected/table_place_helper.dart';
import 'package:flutter_attendance/store/store/protected/table_place_store.dart';
import 'package:get/get.dart';

class TablePlaceController extends GetxController {
  final TablePlaceStore store = Get.put(TablePlaceStore());
  final TablePlaceHelper helper = Get.put(TablePlaceHelper());
}
