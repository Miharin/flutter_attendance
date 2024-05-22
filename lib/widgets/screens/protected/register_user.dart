import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/controller/table_user_controller.dart';
import 'package:flutter_attendance/widgets/templates/buttons/choice_chip.dart';
import 'package:flutter_attendance/widgets/templates/buttons/filled_button.dart';
import 'package:flutter_attendance/widgets/templates/etc/card.dart';
import 'package:flutter_attendance/widgets/templates/inputs/text_form_field.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RegisterUser extends GetView<TableUserController> {
  const RegisterUser({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomCardWithHeader(
        header: "Register",
        children: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomTextFormField(
                  label: "Email",
                  verification: true,
                  controller: controller.helper.controller[0],
                  keyboardType: TextInputType.emailAddress,
                  onSave: (value) => controller.helper
                      .handleAddNewtableContent("Email", value),
                ),
                CustomTextFormField(
                  label: "Password",
                  verification: true,
                  controller: controller.helper.controller[1],
                  onSave: (value) => controller.helper
                      .handleAddNewtableContent("Password", value),
                ),
              ],
            ),
            Row(
              children: [
                CustomTextFormField(
                  label: "Nama",
                  verification: true,
                  controller: controller.helper.controller[2],
                  onSave: (value) =>
                      controller.helper.handleAddNewtableContent("Nama", value),
                ),
                CustomTextFormField(
                  label: "No.Telp",
                  verification: true,
                  controller: controller.helper.controller[3],
                  keyboardType: TextInputType.number,
                  onSave: (value) => controller.helper
                      .handleAddNewtableContent("No.Telp", value),
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
            CustomFilledButton(
              label: "Submit",
              onPressed: () {
                controller.helper.handleSubmitAddDataContent();
              },
            ),
          ],
        ),
      ),
    );
  }
}
