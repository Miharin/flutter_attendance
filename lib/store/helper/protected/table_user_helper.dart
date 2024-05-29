import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/store/protected/table_user_store.dart';
import 'package:get/get.dart';

class TableUserHelper extends GetxController {
  // Form Key
  final formkeyRegister = GlobalKey<FormState>();
  final RxMap<String, dynamic> addNewUser = {
    "Email": "",
    "Password": "",
    "Nama": "",
    "No.Telp": "",
    "Role": "",
  }.obs;
  final controller = List.generate(5, (index) => TextEditingController());
  final index = 1.obs;
  final RxBool disabledSubmitButton = true.obs;

  handleAddNewtableContent(String name, dynamic value) {
    addNewUser[name] = value;
  }

  handleSubmitAddDataContent() {
    final TableUserStore store = Get.put(TableUserStore());
    store.tableContent.add({...addNewUser});
    store.tableContent.refresh();
    store.handleAddToDatabase(addNewUser);
    addNewUser["Role"] = index.value == 1 ? "User" : "Admin";
    for (var element in controller) {
      element.clear();
    }
  }

  handleNewTableContentOnSubmit(RxMap<String, bool> verification) {
    if (verification["Email"]! &&
        verification["Password"]! &&
        verification["Nama"]! &&
        verification["No.Telp"]!) {
      disabledSubmitButton.value = false;
    } else {
      disabledSubmitButton.value = true;
    }
  }
}
