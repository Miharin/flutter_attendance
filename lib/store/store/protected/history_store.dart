import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/shared/models/user_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryStore extends GetxController {
  // Get User Cache Role and Name
  final String cacheRole = cache.read("user")["role"];
  final cacheUsername = cache.read("user")["email"];

  // Data History
  final RxList userDataCheck = [].obs;

  final RxString tahun = "".obs;
  final RxString bulan = "".obs;
  final RxString name = "".obs;

  @override
  void onInit() {
    super.onInit();

    // Fetch This While Building Widgets
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  void getFilteredData() async {
    // Collection
    final timeCollection = db.collection("Timestamp");

    // Query
    Future<QuerySnapshot<Map<String, dynamic>>> query;

    final month = List.generate(
      12,
      (index) =>
          DateFormat("MMMM", "id_ID").format(DateTime(0, index + 1)).toString(),
    );
    if (name.value == "All") {
      query = timeCollection
          .where(
            Filter.and(
              Filter("year",
                  isEqualTo: tahun.value != ""
                      ? tahun.value
                      : DateTime.now().year.toString()),
              Filter(
                "month",
                isEqualTo: bulan.value != ""
                    ? (month.indexWhere((m) => m == bulan.value) + 1).toString()
                    : DateTime.now().month.toString(),
              ),
            ),
          )
          .get();
    } else {
      query = timeCollection
          .where(
            Filter.and(
              Filter("year",
                  isEqualTo: tahun.value != ""
                      ? tahun.value
                      : DateTime.now().year.toString()),
              Filter("month",
                  isEqualTo: bulan.value != ""
                      ? (month.indexWhere((m) => m == bulan.value) + 1)
                          .toString()
                      : DateTime.now().month.toString()),
              Filter("name",
                  isEqualTo: name.value != ""
                      ? name.value
                      : cache.read("user")["name"]),
            ),
          )
          .get();
    }
    userDataCheck.value = [];
    await query.then((snapshot) {
      for (var timestamp in snapshot.docs) {
        for (var timestampData in timestamp["timestamp"]) {
          // Change Type to DateTime from String
          final date = DateTime.parse(timestampData["datetime"]);
          // If DateNow <= Date < DateThen
          if (date.month == DateTime.now().month) {
            // Adding In The UserDataCheck With User History Model Configuratuion
            if (timestampData["type"] == "Lain-Nya") {
              userDataCheck.add(
                UserHistoryModel.fromJson({
                  "datetime": timestampData["datetime"],
                  "latitude": timestampData["latitude"],
                  "longitude": timestampData["longitude"],
                  "status": timestampData["status"],
                  "statusOutside": "Sakit",
                  "type": timestampData["type"],
                  "workplace_id": timestampData["workplace_id"],
                  "alasan": "Sakit",
                }, timestamp["name"])
                    .toMap(),
              );
            } else {
              userDataCheck.add(UserHistoryModel.fromJson(
                timestampData,
                timestamp["name"],
              ).toMap());
            }
          }
        }
      }
    });
  }

  void _getData() async {
    // Date Now
    final date = DateTime.now();

    // Get Year
    final year = date.year;

    // Collection
    final timeCollection = db.collection("Timestamp");

    // Query
    Future<QuerySnapshot<Map<String, dynamic>>> query;

    // If Admin Get ALl Data In Database
    if (cacheRole == "admin") {
      query = timeCollection.where("year", isEqualTo: year.toString()).get();
    }

    // Else Get Data Where Name == Name In Login and this Year
    else {
      query = timeCollection
          .where(
            Filter.and(
              Filter("name", isEqualTo: cacheUsername),
              Filter("year", isEqualTo: year.toString()),
              Filter("month", isEqualTo: date.month),
            ),
          )
          .get();
    }

    // Logic Get Data
    await query.then((timestamps) {
      // Looping Timestamps if cacheRole Admin This Will Loop for a While
      for (var timestamp in timestamps.docs) {
        // Looping Inside Timestamp field Where Main Data History Stored
        for (var timestampData in timestamp["timestamp"]) {
          // Change Type to DateTime from String
          final date = DateTime.parse(timestampData["datetime"]);
          // If DateNow <= Date < DateThen
          if (date.month == DateTime.now().month) {
            // Adding In The UserDataCheck With User History Model Configuratuion
            if (timestampData["type"] == "Lain-Nya") {
              userDataCheck.add(
                UserHistoryModel.fromJson({
                  "datetime": timestampData["datetime"],
                  "latitude": timestampData["latitude"],
                  "longitude": timestampData["longitude"],
                  "status": timestampData["status"],
                  "statusOutside": "Sakit",
                  "type": timestampData["type"],
                  "workplace_id": timestampData["workplace_id"],
                  "alasan": "Sakit",
                }, timestamp["name"])
                    .toMap(),
              );
            } else {
              userDataCheck.add(UserHistoryModel.fromJson(
                timestampData,
                timestamp["name"],
              ).toMap());
            }
          }
        }
      }
    });
  }
}
