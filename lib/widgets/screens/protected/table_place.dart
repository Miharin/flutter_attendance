import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/store/controller/table_place_controller.dart';
import 'package:flutter_attendance/widgets/templates/etc/datatable.dart';
import 'package:flutter_attendance/widgets/templates/inputs/text_form_field.dart';
import 'package:get/get.dart';

class TablePlace extends StatelessWidget {
  TablePlace({super.key});
  final TablePlaceController controller = Get.put(TablePlaceController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db
            .collection("Place")
            .where("workplace", isEqualTo: "Sumber Wringin")
            .snapshots(),
        builder: (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              controller.store.tableContent.value = [];
              for (var data in snapshot.data!.docs[0]["place"]) {
                controller.store.tableContent.add({
                  "ID": data["ID"],
                  "Latitude Start": data["LatitudeStart"],
                  "Latitude End": data["LatitudeEnd"],
                  "Longitude Start": data["LongitudeStart"],
                  "Longitude End": data["LongitudeEnd"],
                });
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          controller.store.tableContent.isEmpty
                              ? const CustomDataTable(
                                  title: [
                                    "ID",
                                    "Latitude Start",
                                    "Latitude End",
                                    "Longitude Start",
                                    "Longitude End",
                                  ],
                                  datalabel: [
                                    {
                                      "ID": "",
                                      "LatitudeStart": "",
                                      "LatitudeEnd": "",
                                      "LongitudeStart": "",
                                      "LongitudeEnd": "",
                                    }
                                  ],
                                )
                              : CustomDataTable(
                                  title: controller.store.tableContent[0].keys
                                      .toList(),
                                  datalabel: controller.store.tableContent,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return CircularProgressIndicator();
        });
  }
}
