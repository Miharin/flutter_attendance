import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/shared/models/square_geofencing_model.dart';
import 'package:flutter_attendance/store/controller/attendance_controller.dart';
import 'package:flutter_attendance/widgets/templates/buttons/filled_button.dart';
import 'package:flutter_attendance/widgets/templates/etc/card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({super.key});

  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    isEnableCheckButton(label) {
      final isLoading = controller.helper.isLoading.value;
      final isCheckIn = controller.store.isCheckIn.value;
      final isCheckOut = controller.store.isCheckOut.value;
      final isAbsent = controller.store.isAbsent.value;
      switch (label) {
        case "Check In":
          if (isLoading || (!isLoading && isCheckIn) || isAbsent) return false;
          return true;
        case "Check Out":
          if (isLoading || (!isLoading && isCheckOut) || isAbsent) return false;
          return true;
        case "Lain-Nya":
          if (isLoading || isAbsent || isCheckIn) return false;
          return true;
        default:
      }
      return false;
    }

    controller.helper.isLoading.value = true;
    Future.delayed(const Duration(seconds: 3))
        .then((result) => controller.helper.isLoading.value = false);

    return StreamBuilder<QuerySnapshot>(
        stream: db
            .collection("Timestamp")
            .where(Filter.and(
              Filter("email", isEqualTo: cache.read("user")["email"]),
              Filter("month", isEqualTo: DateTime.now().month.toString()),
            ))
            .limit(1)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              controller.store.isCheckIn.value = false;
              controller.store.isCheckOut.value = false;
              controller.store.isAbsent.value = false;
              controller.store.datetimeIn.value = "";
              controller.store.datetimeOut.value = "";
              controller.store.indexStatus.value = "";
              for (var datas in snapshot.data!.docs) {
                final List time = datas["timestamp"];
                final searchToday = time.where(
                  (data) =>
                      data["datetime"] != "" &&
                      DateFormat("yyyy-MM-dd").format(DateTime.now()) ==
                          DateFormat("yyyy-MM-dd")
                              .format(DateTime.parse(data["datetime"])),
                );
                final countCheckIn = searchToday
                    .where((data) => data["type"] == "Check In")
                    .length;

                final countCheckOut = searchToday
                    .where((data) => data["type"] == "Check Out")
                    .length;

                final countLainnya = searchToday
                    .where((data) => data["type"] == "Lain-Nya")
                    .length;
                print([countCheckIn, countCheckOut]);

                if (countCheckIn != 0) {
                  if (countCheckIn == 2 ||
                      (countCheckIn == 1 && countLainnya == 1) ||
                      (countCheckIn > countCheckOut)) {
                    controller.store.isCheckIn.value = true;
                  }
                  for (var element in searchToday
                      .where((data) => data["type"] == "Check In")) {
                    controller.store.datetimeIn.value = element["datetime"];
                    controller.store.indexStatus.value =
                        element["alasan"] ?? "";
                  }
                }
                if (countCheckOut != 0) {
                  if (countCheckOut == 2 ||
                      (countCheckOut == 1 && countLainnya == 1) ||
                      countCheckOut == countCheckIn) {
                    controller.store.isCheckOut.value = true;
                  }
                  for (var element in searchToday
                      .where((data) => data["type"] == "Check Out")) {
                    controller.store.datetimeOut.value = element["datetime"];
                    controller.store.indexStatus.value =
                        element["alasan"] ?? "";
                  }
                }
                if (countLainnya != 0) {
                  if (countLainnya == 2) {
                    controller.store.isAbsent.value = true;
                  }
                  for (var element in searchToday
                      .where((data) => data["type"] == "Lain-Nya")) {
                    controller.store.datetimeOut.value = element["datetime"];
                    controller.store.indexStatus.value =
                        element["status"] ?? "";
                  }
                }
                // for (var timestamp in datas["timestamp"]) {
                //   if (timestamp["datetime"] != "") {
                //     final dateNow =
                //         DateFormat("yyyy-MM-dd").format(DateTime.now());
                //     final date = DateFormat("yyyy-MM-dd")
                //         .format(DateTime.parse(timestamp["datetime"]));
                //     if (date == dateNow) {
                //       if (timestamp["type"] == "Check In") {
                //         controller.store.isCheckIn.value = true;
                //         controller.store.datetimeIn.value =
                //             timestamp["datetime"];
                //         controller.store.indexStatus.value =
                //             timestamp["alasan"] ?? "";
                //       } else if (timestamp["type"] == "Check Out") {
                //         controller.store.isCheckOut.value = true;
                //         controller.store.datetimeOut.value =
                //             timestamp["datetime"];
                //         controller.store.indexStatus.value =
                //             timestamp["alasan"] ?? "";
                //       } else if (timestamp["type"] == "Lain-Nya") {
                //         controller.store.isAbsent.value = true;
                //         controller.store.datetimeIn.value = controller
                //             .store.datetimeOut.value = timestamp["datetime"];
                //         controller.store.indexStatus.value =
                //             timestamp["status"];
                //       }
                //     }
                //   }
                // }
              }
              controller.helper.isLoading.value = false;
              return StreamBuilder(
                  stream: db
                      .collection("Place")
                      .where("workplace", isEqualTo: "Sumber Wringin")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      if (snapshot.hasData) {
                        controller.store.geoFencingList.value = [];
                        for (var place in snapshot.data!.docs) {
                          for (var geoFence in place["place"]) {
                            final geoFencing =
                                SquareGeoFencing.fromJson(geoFence);
                            controller.store.geoFencingList.add(geoFencing);
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: CustomFilledButton(
                                        label: "Check In",
                                        onPressed:
                                            isEnableCheckButton("Check In")
                                                ? () => controller.helper
                                                        .handleTimechange(
                                                      "Check In",
                                                      context,
                                                    )
                                                : null,
                                      ),
                                    ),
                                    Flexible(
                                      child: CustomFilledButton(
                                        label: "Check Out",
                                        onPressed:
                                            isEnableCheckButton("Check Out")
                                                ? () => controller.helper
                                                        .handleTimechange(
                                                      "Check Out",
                                                      context,
                                                    )
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: CustomFilledButton(
                                    label: "Lain-Nya",
                                    onPressed: isEnableCheckButton("Lain-Nya")
                                        ? () =>
                                            controller.helper.handleTimechange(
                                              "Lain-Nya",
                                              context,
                                            )
                                        : null,
                                  ),
                                ),
                                AnimatedCrossFade(
                                    firstChild: mobileScreen(),
                                    secondChild: desktopScreen(),
                                    crossFadeState:
                                        MediaQuery.of(context).size.width > 800
                                            ? CrossFadeState.showSecond
                                            : CrossFadeState.showFirst,
                                    duration:
                                        const Duration(milliseconds: 500)),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    return const CircularProgressIndicator();
                  });
            }
          }
          return const CircularProgressIndicator();
        });
  }

  Widget mobileScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: CustomCardWithHeader(
            header: "Check In",
            children: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.store.datetimeIn.value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: CustomCardWithHeader(
            header: "Check Out",
            children: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.store.datetimeOut.value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: CustomCardWithHeader(
            isGap: false,
            header: "Lain-Nya",
            children: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.store.indexStatus.value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget desktopScreen() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 150.0),
            child: CustomCardWithHeader(
              header: "Check In",
              children: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.store.datetimeIn.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 150.0),
            child: CustomCardWithHeader(
              header: "Check Out",
              children: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.store.datetimeOut.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 150.0),
            child: CustomCardWithHeader(
              isGap: false,
              header: "Lain-Nya",
              children: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    controller.store.indexStatus.value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
