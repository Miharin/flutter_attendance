import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/shared/models/user_model.dart';
import 'package:flutter_attendance/store/controller/history_controller.dart';
import 'package:flutter_attendance/widgets/templates/etc/datatable.dart';
import 'package:flutter_attendance/widgets/templates/inputs/dropdown.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class History extends StatelessWidget {
  History({super.key});
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: cache.read("user")["role"] == "admin"
            ? db
                .collection("Timestamp")
                .where(
                  Filter.and(
                    Filter("year", isEqualTo: DateTime.now().year.toString()),
                    Filter("month", isEqualTo: DateTime.now().month.toString()),
                  ),
                )
                .snapshots()
            : db
                .collection("Timestamp")
                .where(
                  Filter.and(
                    Filter("email", isEqualTo: cache.read("user")["email"]),
                    Filter("year", isEqualTo: DateTime.now().year.toString()),
                    Filter("month", isEqualTo: DateTime.now().month.toString()),
                  ),
                )
                .snapshots(),
        builder: (context, snapshot) {
          final List name = ["All"];
          if (snapshot.hasData) {
            controller.store.userDataCheck.value = [];
            for (var data in snapshot.data!.docs) {
              for (var timestamp in data["timestamp"]) {
                name.add(data["name"]);
                if (timestamp["type"] == "Lain-Nya") {
                  controller.store.userDataCheck.add(
                    UserHistoryModel.fromJson({
                      "datetime": timestamp["datetime"],
                      "latitude": timestamp["latitude"],
                      "longitude": timestamp["longitude"],
                      "status": timestamp["status"],
                      "statusOutside": "Sakit",
                      "type": timestamp["type"],
                      "workplace_id": timestamp["workplace_id"],
                      "alasan": "Sakit",
                    }, timestamp["name"])
                        .toMap(),
                  );
                } else {
                  controller.store.userDataCheck.add(
                      UserHistoryModel.fromJson(timestamp, data["name"])
                          .toMap());
                }
              }
            }
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomDropDown(
                        list: List.generate(
                          5,
                          (index) =>
                              ((DateTime.now().year - 2) + index).toString(),
                        ),
                        label: "Tahun",
                        verification: true,
                        onSelected: (selected) {
                          controller.store.tahun.value = selected!;
                          controller.store.getFilteredData();
                        },
                      ),
                      CustomDropDown(
                        list: List.generate(
                          12,
                          (index) => DateFormat("MMMM", "id_ID")
                              .format(DateTime(0, index + 1))
                              .toString(),
                        ),
                        label: "Bulan",
                        verification: true,
                        onSelected: (selected) {
                          controller.store.bulan.value = selected!;
                          controller.store.getFilteredData();
                        },
                      ),
                      CustomDropDown(
                        list: name.toSet().toList(),
                        label: "Nama",
                        verification: true,
                        onSelected: (selected) {
                          controller.store.name.value = selected!;
                          controller.store.getFilteredData();
                        },
                      ),
                    ],
                  ),
                ),
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
          );
        });
  }
}
