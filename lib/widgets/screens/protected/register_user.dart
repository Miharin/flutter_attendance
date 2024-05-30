import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/controller/table_user_controller.dart';
import 'package:flutter_attendance/widgets/templates/buttons/choice_chip.dart';
import 'package:flutter_attendance/widgets/templates/buttons/filled_button.dart';
import 'package:flutter_attendance/widgets/templates/etc/card.dart';
import 'package:flutter_attendance/widgets/templates/etc/form.dart';
import 'package:flutter_attendance/widgets/templates/inputs/text_form_field.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RegisterUser extends StatelessWidget {
  RegisterUser({super.key});
  final TableUserController controller = Get.put(TableUserController());

  @override
  Widget build(BuildContext context) {
    return CustomCardWithHeader(
      header: "Register",
      children: CustomForm(
        formKey: controller.helper.formkeyRegister,
        onChanged: () => controller.helper.handleNewTableContentOnSubmit(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomTextFormField(
                  label: "Email",
                  verification:
                      controller.validator.registerUserVerfication["Email"]!,
                  controller: controller.helper.controller[0],
                  keyboardType: TextInputType.emailAddress,
                  onSave: (value) => controller.helper
                      .handleAddNewtableContent("Email", value),
                  validator: (value) =>
                      controller.validator.validatorRegisterUser(
                    "Email",
                    value ?? "",
                  ),
                ),
                Obx(() => CustomTextFormField(
                      label: "Password",
                      obscureText: controller.helper.obscureTextPassword.value,
                      verification: controller
                          .validator.registerUserVerfication["Password"]!,
                      controller: controller.helper.controller[1],
                      onSave: (value) => controller.helper
                          .handleAddNewtableContent("Password", value),
                      validator: (value) =>
                          controller.validator.validatorRegisterUser(
                        "Password",
                        value ?? "",
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.helper.handleObscureText();
                        },
                        icon: controller.helper.obscureTextPassword.value
                            ? const Icon(
                                Icons.visibility,
                              )
                            : const Icon(
                                Icons.visibility_off,
                              ),
                      ),
                    )),
              ],
            ),
            Row(
              children: [
                CustomTextFormField(
                  label: "Nama",
                  keyboardType: TextInputType.name,
                  verification:
                      controller.validator.registerUserVerfication["Nama"]!,
                  controller: controller.helper.controller[2],
                  onSave: (value) =>
                      controller.helper.handleAddNewtableContent("Nama", value),
                  validator: (value) =>
                      controller.validator.validatorRegisterUser(
                    "Nama",
                    value ?? "",
                  ),
                ),
                CustomTextFormField(
                  label: "No.Telp",
                  verification:
                      controller.validator.registerUserVerfication["No.Telp"]!,
                  controller: controller.helper.controller[3],
                  keyboardType: TextInputType.number,
                  onSave: (value) => controller.helper
                      .handleAddNewtableContent("No.Telp", value),
                  validator: (value) =>
                      controller.validator.validatorRegisterUser(
                    "No.Telp",
                    value ?? "",
                  ),
                ),
              ],
            ),
            CustomCardWithHeader(
              header: "Role",
              children: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (int index) {
                    final List<String> title = ["Admin", "User"];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: CustomChoiceChip(
                          content: title[index],
                          selected: controller.helper.index.value == index,
                          onSelected: (bool selected) {
                            if (selected) {
                              controller.helper.index.value = index;
                            }
                          }),
                    );
                  }),
                ),
              ),
            ),
            const Gap(10.0),
            Obx(() => controller.helper.isLoading.value
                ? const CircularProgressIndicator()
                : CustomFilledButton(
                    label: "Add New User",
                    onPressed: controller.helper.disabledSubmitButton.value
                        ? null
                        : () => controller.helper.handleSubmitAddDataContent(),
                  )),
          ],
        ),
      ),
    );
  }
}
