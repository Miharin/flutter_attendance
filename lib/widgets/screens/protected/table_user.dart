import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/controller/table_user_controller.dart';
import 'package:flutter_attendance/widgets/templates/etc/datatable.dart';
import 'package:flutter_attendance/widgets/templates/inputs/text_form_field.dart';
import 'package:get/get.dart';

class TableUser extends GetView<TableUserController> {
  const TableUser({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: Column(
          children: [
            Obx(
              () => Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.store.tableContent.isEmpty
                        ? const CustomDataTable(
                            title: [
                              "Email",
                              "Password",
                              "Nama",
                              "No.Telp",
                            ],
                            datalabel: [
                              {
                                "Email": "",
                                "Password": "",
                                "Nama": "",
                                "No.Telp": "",
                              }
                            ],
                          )
                        : CustomDataTable(
                            title:
                                controller.store.tableContent[0].keys.toList(),
                            datalabel: controller.store.tableContent,
                            ontap: () => showBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomTextFormField(
                                          label: ":D",
                                          verification: true,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
