import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/helper/protected/table_place_helper.dart';
import 'package:flutter_attendance/widgets/templates/etc/datatable.dart';
import 'package:flutter_attendance/widgets/templates/inputs/text_form_field.dart';
import 'package:get/get.dart';

class TablePlace extends StatelessWidget {
  TablePlace({super.key});

  final tablePlaceHelper = Get.put(TablePlaceHelper());

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
                    tablePlaceHelper.tableContent.isEmpty
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
                            title:
                                tablePlaceHelper.tableContent[0].keys.toList(),
                            datalabel: tablePlaceHelper.tableContent,
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
