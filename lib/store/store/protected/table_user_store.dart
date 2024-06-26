import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:get/get.dart';

class TableUserStore extends GetxController {
  final RxList tableTitle = [].obs;
  final RxList tableContent = [].obs;

  handleAddToDatabase(Map<String, dynamic> addNewUser) async {
    try {
      final checkUserPhoneNumber = await db
          .collection("Users")
          .where("telp_number", isEqualTo: addNewUser["No.Telp"])
          .limit(1)
          .get()
          .then((user) {
        return user.docs.isNotEmpty;
      });
      if (checkUserPhoneNumber) {
        Get.snackbar(
          "Penambahan User Gagal",
          "Nomer Telpon Sudah Ada",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        await auth
            .createUserWithEmailAndPassword(
                email: addNewUser["Email"], password: addNewUser["Password"])
            .then((userCredentials) async {
          if (userCredentials.user?.uid.runtimeType != null) {
            final users = db.collection("Users");
            final data = {
              "email": addNewUser["Email"],
              "name": addNewUser["Nama"],
              "password": addNewUser["Password"],
              "role": addNewUser["Role"],
              "telp_number": addNewUser["No.Telp"],
            };
            await users
                .doc(userCredentials.user?.uid)
                .set(data)
                .then((result) => Get.snackbar(
                      "Penambahan User Berhasil !",
                      "User Dengan Nama ${addNewUser["Nama"]} Berhasil Di Tambahkan",
                    ))
                .then((_) => tableContent.add(data));
          }
        });
      }
    } on FirebaseAuthException catch (error) {
      String errorMassage = "";
      if (error.code == "netwrok=request-failed") {
        errorMassage = "Database Timeout";
      } else if (error.code == "invalid-credential") {
        errorMassage = "Email Atau Password Salah";
      } else {
        errorMassage = error.toString();
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
