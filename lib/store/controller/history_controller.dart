import 'package:flutter_attendance/store/helper/protected/history_helper.dart';
import 'package:flutter_attendance/store/store/protected/history_store.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final HistoryStore store = Get.put(HistoryStore());
  final HistoryHelper helper = Get.put(HistoryHelper());
}
