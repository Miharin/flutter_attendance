import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/controller/auth_controller.dart';
import 'package:flutter_attendance/widgets/templates/etc/card.dart';
import 'package:flutter_attendance/widgets/templates/etc/form.dart';
import 'package:flutter_attendance/widgets/templates/etc/text.dart';
import 'package:flutter_attendance/widgets/templates/inputs/text_form_field.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:flutter_attendance/widgets/templates/buttons/filled_button.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      // Constrained For Text Field
      var constrained = BoxConstraints(
        maxWidth: constraint.maxWidth > 500 ? 500 : constraint.maxWidth * 0.8,
        minWidth: constraint.maxWidth > 500 ? 500 : constraint.maxWidth * 0.8,
      );

      // Return
      return Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: constrained,
            child: FlatCard(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header
                    const Header(child: "Login"),
                    const Gap(10.0),

                    // Email and Password Text Field with Map
                    // textFields,
                    CustomForm(
                      formKey: controller.helper.formKeyLogin,
                      onChanged: () {
                        controller.helper.handleSignInButton(
                          controller.validator.authVerification,
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextFormField(
                            focusNode: controller.helper.focusEmail,
                            label: "Email",
                            verification:
                                controller.validator.authVerification["email"]!,
                            onSave: (value) => controller
                              ..helper.handleLoginTextFormFieldChanged(
                                "email",
                                value ?? "",
                              ),
                            validator: (value) =>
                                controller.validator.validatorLogin(
                              "email",
                              value ?? "",
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Obx(
                            () => CustomTextFormField(
                              focusNode: controller.helper.focusPassword,
                              label: "Password",
                              obscureText:
                                  controller.helper.obscureTextPassword.value,
                              verification: controller
                                  .validator.authVerification["password"]!,
                              onSave: (value) => controller.helper
                                  .handleLoginTextFormFieldChanged(
                                "password",
                                value ?? "",
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.helper.handleObscureText();
                                },
                                icon:
                                    controller.helper.obscureTextPassword.value
                                        ? const Icon(
                                            Icons.visibility,
                                          )
                                        : const Icon(
                                            Icons.visibility_off,
                                          ),
                              ),
                              validator: (value) {
                                return controller.validator.validatorLogin(
                                  "password",
                                  value ?? "",
                                );
                              },
                              keyboardType: TextInputType.visiblePassword,
                            ),
                          ),

                          const Gap(10.0),
                          // Button to Input Token

                          Obx(() {
                            if (controller.store.isLoading.value) {
                              return const CircularProgressIndicator();
                            } else {
                              return CustomFilledButton(
                                label: "Login",
                                onPressed: controller
                                        .helper.disabledSignInButton.value
                                    ? null
                                    : () {
                                        controller.store.signIn(
                                          controller.helper.authData["email"],
                                          controller
                                              .helper.authData["password"],
                                        );
                                      },
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
