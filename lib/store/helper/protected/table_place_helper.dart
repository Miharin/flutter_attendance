import 'package:flutter_attendance/store/store/protected/table_place_store.dart';
import 'package:get/get.dart';

class TablePlaceHelper extends GetxController {
  final RxMap<String, dynamic> addNewTableContentData = {
    "ID": "",
    "LatitudeStart": "",
    "LatitudeEnd": "",
    "LongitudeStart": "",
    "LongitudeEnd": "",
  }.obs;
  final RxBool isLoading = false.obs;

  handleAddNewtableContent(String name, dynamic value) {
    addNewTableContentData[name] = value;
  }

  handleSubmitAddDataContent() {
    isLoading.value = true;
    final TablePlaceStore store = Get.put(TablePlaceStore());
    store.tableContent.add({...addNewTableContentData});
    store.tableContent.refresh();
    store.handleAddToDatabase(addNewTableContentData);
    isLoading.value = false;
  }

  handleNewTableContentOnSubmit() {
    final TablePlaceStore store = Get.put(TablePlaceStore());
    store.tableContent.add(addNewTableContentData);
    store.tableContent.refresh();
  }
}
