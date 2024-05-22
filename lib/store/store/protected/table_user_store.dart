import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:get/get.dart';

class TableUserStore extends GetxController {
  final RxList tableTitle = [].obs;
  final RxList tableContent = [].obs;

  handleAddToDatabase(Map<String, dynamic> addNewUser) async {
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: addNewUser["Email"], password: addNewUser["Password"])
          .then((userCredentials) async {
        if (userCredentials.user?.uid.runtimeType != null) {
          final users = db.collection("Users");
          await users.doc(userCredentials.user?.uid).set({
            "email": addNewUser["Email"],
            "name": addNewUser["Nama"],
            "password": addNewUser["Pawssword"],
            "role": addNewUser["Role"],
            "telp_number": addNewUser["No.Telp"],
          }).then((result) => Get.snackbar(
                "Penambahan User Berhasil !",
                "User Dengan Nama ${addNewUser["Nama"]} Berhasil Di Tambahkan",
              ));
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
