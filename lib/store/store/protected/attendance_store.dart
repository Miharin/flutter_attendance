import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/shared/models/square_geofencing_model.dart';
import 'package:flutter_attendance/store/helper/protected/attendance_helper.dart';
import 'package:get/get.dart';
import "package:intl/intl.dart";

class AttendanceStore extends GetxController {
  final RxList<SquareGeoFencing> geoFencingList = const [
    SquareGeoFencing(
        id: "",
        latitudeStart: 0.00,
        latitudeEnd: 0.00,
        longitudeStart: 0.00,
        longitudeEnd: 0.00),
  ].obs;
  final RxBool isCheckIn = false.obs;
  final RxBool isCheckOut = false.obs;
  final RxString datetimeIn = "".obs;
  final RxString datetimeOut = "".obs;
  final RxInt index = 0.obs;
  final RxString indexStatus = "".obs;
  final RxString indexAlasan = "".obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  void _getData() async {
    final isHasData = cache.read("userIsLogin");
    if (isHasData) {
      final collection = db.collection("Timestamp");
      final query = collection
          .where("name", isEqualTo: cache.read("user")["name"])
          .limit(1)
          .get();
      await query.then((datas) {
        for (var data in datas.docs) {
          for (var timestamp in data["timestamp"]) {
            final dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());
            final date = DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(timestamp["datetime"]));
            if (date == dateNow && timestamp["type"] == "Check In") {
              isCheckIn.value = true;
            } else if (date == dateNow && timestamp["type"] == "Check Out") {
              isCheckOut.value = true;
            }
          }
        }
      });
      final collectionGeo = db.collection("Place");
      final queryGeo = collectionGeo
          .where("workplace", isEqualTo: "Sumber Wringin")
          .limit(1)
          .get();
      geoFencingList.value = [];
      await queryGeo.then((places) {
        for (var place in places.docs) {
          for (var geoFence in place["place"]) {
            final geoFencing = SquareGeoFencing.fromJson(geoFence);
            geoFencingList.add(geoFencing);
          }
        }
      });
      GeoFencing.square(
              listSquareGeoFencing: <SquareGeoFencing>[...geoFencingList])
          .listGeoFencing()
          .then((value) => print(value));
    }
  }

  addToDatabase(RxMap<String, dynamic> timestampData) async {
    final AttendanceHelper helper = Get.put(AttendanceHelper());
    if (timestampData["timestamp"]["status"] == "Outside Workplace") {
      indexStatus.value = index.value == 0 ? "Sakit" : "Ijin";
      timestampData["timestamp"]["statusOutside"] = indexStatus.value;
      timestampData["timestamp"]["alasan"] =
          index.value == 0 ? indexStatus.value : indexAlasan.value;
    }
    print(timestampData);
    final timestamp = db.collection("Timestamp");
    final queryTimestamp =
        timestamp.where("name", isEqualTo: timestampData["name"]).get();
    await queryTimestamp.then((timestamp) {
      if (timestamp.docs.isEmpty) {
        db.collection("Timestamp").doc().set({
          "name": timestampData["name"],
          "last_edit": Timestamp.now(),
          "timestamp": [timestampData["timestamp"]]
        }).onError(
            (error, stackTrace) => print("Error Writing Document: $error"));
      } else {
        for (var data in timestamp.docs) {
          db.collection("Timestamp").doc(data.id).update({
            "last_edit": Timestamp.now(),
            "timestamp": FieldValue.arrayUnion(
              [timestampData["timestamp"]],
            )
          }).onError(
              (error, stackTrace) => print("Error Writing Document: $error"));
        }
      }
    });
    helper.isLoading.value = false;
  }
}
