import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/shared/models/user_model.dart';
import 'package:get/get.dart';

class HistoryStore extends GetxController {
  // Get User Cache Role and Name
  final String cacheRole = cache.read("user")["role"];
  final cacheUsername = cache.read("user")["name"];

  // Data History
  final RxList userDataCheck = [].obs;

  @override
  void onInit() {
    super.onInit();

    // Fetch This While Building Widgets
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  void _getData() async {
    // Date Now
    final date = DateTime.now();

    // Get Year
    final year = date.year;

    // Collection
    final timeCollection = db.collection("TimeStamp");

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
          final date = DateTime.parse(timestampData["DateTime"]);
          // If DateNow <= Date < DateThen
          if (date.month == DateTime.now().month) {
            // Adding In The UserDataCheck With User History Model Configuratuion
            if (timestampData["type"] == "Lain-Nya") {
              userDataCheck.add({
                "name": timestamp["name"],
                "dateTime": DateTime.parse(timestampData["DateTime"]),
                "latitude": double.parse(timestampData["latitude"]),
                "longitude": double.parse(timestampData["longitude"]),
                "status": timestampData["status"],
                "statusOutside": "Sakit",
                "type": timestampData["type"],
                "workplaceID": timestampData["workplaceId"],
                "alasan": "Sakit",
              });
            } else {
              userDataCheck.add(UserHistoryModel.fromJson(
                timestampData,
                timestamp["name"],
              ));
            }
            // Test Data
            print(timestampData);
          }
        }
      }
    });
  }
}
