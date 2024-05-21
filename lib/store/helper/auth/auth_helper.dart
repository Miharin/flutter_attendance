import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthHelper extends GetxController {
  // Form Key
  final formKeyLogin = GlobalKey<FormState>();

  // Focus Node
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPassword = FocusNode();

  // Auth Data
  final RxMap<String, dynamic> authData = {
    "email": "",
    "password": "",
  }.obs;

  // Obscure Text
  final RxBool obscureTextPassword = true.obs;

  // Button Sign In Disabled ?
  final RxBool disabledSignInButton = true.obs;

  // Handle Obscure Text
  handleObscureText() => obscureTextPassword.value = !obscureTextPassword.value;

  // Handle Change from TextFormField
  void handleLoginTextFormFieldChanged(String name, String value) =>
      authData[name] = value;

  // Handle Sign In Button
  void handleSignInButton(RxMap<String, bool> verification) {
    if (verification["email"]! && verification["password"]!) {
      disabledSignInButton.value = false;
    } else {
      disabledSignInButton.value = true;
    }
  }
}
