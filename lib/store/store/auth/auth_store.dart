import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/shared/models/user_model.dart';
import 'package:get/get.dart';

class AuthStore extends GetxController {
  // Loading State
  final RxBool isLoading = false.obs;

  // User Is Login ?
  final RxBool userIsLogin = false.obs;

  // Check User Auth
  Stream<User?> checkAuthState() {
    return auth.authStateChanges();
  }

  // Check User Is Login or Not
  checkIsUserLogin(String? uid) async {
    // If UID == NULL,then userIsLogin = false
    if (uid!.isEmpty) {
      userIsLogin.value = false;
    } else {
      // Read Cache User
      final user = cache.read("user");

      // If Not NULL return TRUE otherwise FALSE
      if (user != null) {
        userIsLogin.value = true;
      } else {
        userIsLogin.value = false;
      }
    }

    // Write Cache userIsLogin
    cache.write("userIsLogin", userIsLogin.value);
  }

  // Handle Sign In
  void signIn(String email, String password) async {
    // Set Loading to TRUE
    isLoading.value = true;

    // Declare ERROR MESSAGE
    String errorMessage = "";

    // Try SIGN IN with Email and Password Provided by USER
    try {
      await auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((UserCredential userCredential) async {
        // Get Data Login USER if Success
        final userCollection = db.collection("Users");
        final query = userCollection.doc(userCredential.user?.uid).get();
        await query.then((user) async {
          if (user.data()!.isNotEmpty) {
            // Make User Data With User Model
            final userData = UserModel.fromJSON(user.data()!);

            // Send to CACHE With Name "User"
            cache.write("user", {
              "email": userData.email,
              "name": userData.name,
              "password": userData.password,
              "role": userData.role,
              "telpNumber": userData.number,
            });

            // Set USER Is Login to TRUE
            userIsLogin.value = true;

            // Set userIsLogin to CACHE
            cache.write("userIsLogin", userIsLogin.value);

            // Inform USER with a Snackbar
            return Get.snackbar(
              "Login Success",
              "Welcome ${userData.name}",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        });
      });
    } on FirebaseAuthException catch (error) {
      // If ERROR From Firebase
      if (error.code == "network-request-failed") {
        errorMessage = "Database Timeout";
      } else if (error.code == "invalid-credential") {
        errorMessage = "Email atau Password Salah";
      }

      // Inform USER
      Get.snackbar(
        "Login Gagal !",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      // if Error From System
      debugPrint(error.toString());
    }
    isLoading.value = false;
  }

  // Sign Out Function
  signOut(bool isLogin) async {
    try {
      await auth.signOut().then((value) {
        debugPrint("Logout");
        Get.snackbar("Logout Success !", "");
        cache.write("userIsLogin", false);
        isLogin = false;
      });
    } catch (error) {
      debugPrint(error.toString());
      Get.snackbar("Logout Gagal", "");
    }
  }
}
