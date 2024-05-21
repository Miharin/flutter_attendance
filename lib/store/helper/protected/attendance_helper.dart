import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/shared/models/square_geofencing_model.dart';
import 'package:flutter_attendance/store/store/protected/attendance_store.dart';
import 'package:flutter_attendance/widgets/templates/buttons/choice_chip.dart';
import 'package:flutter_attendance/widgets/templates/buttons/filled_button.dart';
import 'package:flutter_attendance/widgets/templates/inputs/text_form_field.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceHelper extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isDisabledButtonSubmit = true.obs;
  final RxMap<String, dynamic> timeStampData = {
    "name": "",
    "last_edit": "",
    "timestamp": {
      "latitude": "",
      "longitude": "",
      "status": "",
      "workplace_id": "",
      "datetime": "",
      "type": "",
    },
  }.obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Geolocator.requestPermission().then((permission) {
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          Get.snackbar("Lokasi Tidak Di Izinkan !", "");
        }
      });
    });
  }

  handleChange(
    bool selected,
    int indexSelected,
    int indexPrev,
    String indexStatus,
  ) async {
    indexStatus = indexSelected == 1 ? "Ijin" : "Sakit";
    if (selected) {
      indexPrev = indexSelected;
    }
    return indexPrev;
  }

  handleAlasan(String alasan, String indexAlasan) {
    indexAlasan = alasan;
    if (alasan.isNotEmpty) {
      isDisabledButtonSubmit.value = false;
    }
  }

  handleTimechange(
    String label,
    BuildContext context,
  ) async {
    isLoading.value = true;
    final AttendanceStore store = Get.put(AttendanceStore());
    final String currentUsername = cache.read("user")["name"];
    if (label == "Check In") {
      store.datetimeIn.value =
          DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()).toString();
      store.isCheckIn.value = true;
    } else if (label == "Check Out") {
      store.datetimeOut.value =
          DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()).toString();
      store.isCheckOut.value = true;
    }
    final bool isInside = await GeoFencing.square(
            listSquareGeoFencing: <SquareGeoFencing>[...store.geoFencingList])
        .isInsideSquareGeoFencing();

    final Position position = await Geolocator.getCurrentPosition();
    final String currentLatitude = position.latitude.toStringAsFixed(7);
    final String currentLongitude = position.longitude.toStringAsFixed(7);
    timeStampData["name"] = currentUsername;
    timeStampData["timestamp"]["latitude"] = currentLatitude;
    timeStampData["timestamp"]["longitude"] = currentLongitude;
    if (label == "Check In") {
      timeStampData["timestamp"]["datetime"] = store.datetimeIn.value;
    } else if (label == "Check Out") {
      timeStampData["timestamp"]["datetime"] = store.datetimeOut.value;
    }
    timeStampData["timestamp"]["type"] = label;
    if (!isInside) {
      timeStampData["timestamp"]["status"] = "Outside Workplace";
      timeStampData["timestamp"]["workplace_id"] = "Unknown";
      Get.snackbar("Diluar Tempat Kerja", "");
      if (!context.mounted) return;
      return widgetOutsideWorkplace(context);
    } else {
      timeStampData["timestamp"]["status"] = "Inside Workplace";
      Get.snackbar("Didalam Tempat Kerja", "");
    }
  }

  Future<dynamic> widgetOutsideWorkplace(context) {
    return showModalBottomSheet(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height * 0.5,
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      context: context,
      builder: (BuildContext context) {
        return GetBuilder(
            init: AttendanceStore(),
            builder: (controller) {
              return Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Obx(() => Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(2, (int index) {
                                final List<String> title = ["Sakit", "Ijin"];
                                return CustomChoiceChip(
                                  content: title[index],
                                  selected: controller.index.value == index,
                                  onSelected: (bool selected) async =>
                                      controller.index.value =
                                          await handleChange(
                                    selected,
                                    index,
                                    controller.index.value,
                                    controller.indexStatus.value,
                                  ),
                                );
                              }),
                            )),
                        const Gap(10.0),
                        Obx(() => controller.index.value == 1
                            ? CustomTextFormField(
                                label: "Alasan",
                                verification: true,
                                maxlines: 3,
                                keyboardType: TextInputType.multiline,
                                onSave: (value) => handleAlasan(
                                  value!,
                                  controller.indexAlasan.value,
                                ),
                              )
                            : const Flexible(child: Text(""))),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Obx(() => CustomFilledButton(
                          onPressed: controller.index.value == 1
                              ? isDisabledButtonSubmit.value
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                      controller.addToDatabase(timeStampData);
                                    }
                              : () {
                                  Navigator.pop(context);
                                  controller.addToDatabase(timeStampData);
                                },
                          label: "Submit",
                        )),
                  ),
                ],
              );
            });
      },
    );
  }
}
