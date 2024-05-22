import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:get/get.dart';

class TablePlaceStore extends GetxController {
  final RxList tableTitle = [].obs;
  final RxList tableContent = [].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  getData() async {
    tableContent.value = [];
    final locationCollection = db.collection("Place");
    final locationQuery = locationCollection
        .where("workplace", isEqualTo: "Sumber Wringin")
        .limit(1)
        .get();
    await locationQuery.then((locations) {
      for (var location in locations.docs) {
        for (var locationPlace in location.data()["place"]) {
          tableContent.value = [
            ...tableContent,
            {
              "ID": locationPlace["ID"],
              "Latitude Start": locationPlace["LatitudeStart"],
              "Latitude End": locationPlace["LatitudeEnd"],
              "Longitude Start": locationPlace["LongitudeStart"],
              "Longitude End": locationPlace["LongitudeEnd"],
            }
          ];
        }
      }
    });
  }

  handleAddToDatabase(Map<String, dynamic> addNewTableContent) async {
    final placeCollection = db.collection("Place");
    final queryPlace =
        placeCollection.where("workplace", isEqualTo: "Sumber Wringin").get();

    await queryPlace.then((places) {
      if (places.docs.isEmpty) {
        db.collection("Place").doc().set({
          "place": [addNewTableContent]
        });
      } else {
        for (var place in places.docs) {
          for (var placeData in place.data()["place"]) {
            if (placeData["ID"] == addNewTableContent["ID"]) {
              Get.snackbar(
                "Gagal Menyimpan !",
                "Tempat Dengan Nama ${addNewTableContent["ID"]} Sudah Ada",
              );
            } else {
              db.collection("Place").doc(place.id).update({
                "place": FieldValue.arrayUnion([addNewTableContent])
              });
              Get.snackbar(
                "Berhasil Menyimpan",
                "Tempat Dengan Nama${addNewTableContent["ID"]} Telah Ditambahkan",
              );
            }
          }
        }
      }
    }).then((value) => Get.toNamed("/registered-location"));
  }
}
