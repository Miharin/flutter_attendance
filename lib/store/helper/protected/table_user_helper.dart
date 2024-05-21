import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:get/get.dart';

class TableUserHelper extends GetxController {
  final RxList tableTitle = [].obs;
  final RxList tableContent = [].obs;
  final RxMap<String, dynamic> addNewTableContentData = {
    "Email": "",
    "Password": "",
    "Nama": "",
    "No.Telp": "",
  }.obs;
  final controller = List.generate(5, (index) => TextEditingController());

  handleAddNewtableContent(String name, dynamic value) {
    addNewTableContentData[name] = value;
  }

  handleSubmitAddDataContent() {
    tableContent.add({...addNewTableContentData});
    tableContent.refresh();
    handleAddToDatabase();
    for (var element in controller) {
      element.clear();
    }
  }

  handleNewTableContentOnSubmit() {
    tableContent.add(addNewTableContentData);
    tableContent.refresh();
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  handleAddToDatabase() async {
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: addNewTableContentData["Email"],
              password: addNewTableContentData["Password"])
          .then((userCredential) async {
        if (userCredential.user?.uid.runtimeType != null) {
          final users = db.collection("Users");
          await users.doc(userCredential.user?.uid).set({
            "email": addNewTableContentData["Email"],
            "name": addNewTableContentData["Nama"],
            "password": addNewTableContentData["Pawssword"],
            "role": addNewTableContentData["Role"],
            "telp_number": addNewTableContentData["No.Telp"],
          }).then((result) => Get.snackbar("Penambahan User Berhasil",
              "User Dengan Nama ${addNewTableContentData["Nama"]} Berhasil Di Tambahkan"));
        }
      });
    } on FirebaseAuthException catch (error) {
      String errorMassage = "";
      if (error.code == "netwrok=request-failed") {
        errorMassage = "Database Timeout";
      } else if (error.code == "invalid-credential") {
        errorMassage = "Email Atau Password Salah";
      }
      Get.snackbar(
        "Penambahan User Gagal",
        errorMassage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
