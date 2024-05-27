import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/controller/history_controller.dart';
import 'package:flutter_attendance/widgets/templates/etc/datatable.dart';
import 'package:get/get.dart';

class History extends StatelessWidget {
  History({super.key});
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: Column(
          children: [
            Obx(() => Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      controller.store.userDataCheck.isEmpty
                          ? const CustomDataTable(title: [
                              "name",
                              "dateTime",
                              "latitude",
                              "Longitude",
                              "status",
                              "statusOutside",
                              "type",
                              "workPlaceID",
                              "alasan",
                            ], datalabel: [
                              {
                                "name": "",
                                "dateTime": "",
                                "latitude": "",
                                "Longitude": "",
                                "status": "",
                                "statusOutside": "",
                                "type": "",
                                "workPlaceID": "",
                                "alasan": "",
                              }
                            ])
                          : CustomDataTable(
                              title: const [
                                "name",
                                "dateTime",
                                "latitude",
                                "longitude",
                                "status",
                                "statusOutside",
                                "type",
                                "workplaceID",
                                "alasan",
                              ],
                              datalabel: controller.store.userDataCheck,
                            )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
