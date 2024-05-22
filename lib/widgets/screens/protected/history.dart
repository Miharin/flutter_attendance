import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/controller/history_controller.dart';
import 'package:flutter_attendance/widgets/templates/etc/datatable.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class History extends GetView<HistoryController> {
  const History({super.key});

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
                      controller.store.tableContent.isEmpty
                          ? const CustomDataTable(title: [
                              "name",
                              "dateTime",
                              "latitude",
                              "Longitude",
                              "status",
                              "statusOutside",
                              "type",
                              "workPlaceID",
                              "alsan",
                            ], datalabel: [
                              {
                                "name",
                                "dateTime",
                                "latitude",
                                "Longitude",
                                "status",
                                "statusOutside",
                                "type",
                                "workPlaceID",
                                "alsan"
                              }
                            ])
                          : CustomDataTable(
                              title: controller.store.tableContent[0].keys
                                  .toList(),
                              datalabel: controller.store.tableContent,
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
