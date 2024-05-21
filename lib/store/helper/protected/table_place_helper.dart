import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TablePlaceHelper extends GetxController {
  final RxList tableTitle = [].obs;
  final RxList tableContent = [].obs;
  final RxMap<String, dynamic> addNewTableContentData = {
    "ID": "",
    "LatitudeStart": "",
    "LatitudeEnd": "",
    "LongitudeStart": "",
    "LongitudeEnd": "",
  }.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  Future getData() async {
    tableContent.value = [];
    final locationCollection = db.collection("Place");
    final locationQuery = locationCollection
        .where("workplace", isEqualTo: "Sumber Wringin")
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

  handleAddNewtableContent(String name, dynamic value) {
    addNewTableContentData[name] = value;
  }

  handleSubmitAddDataContent() {
    tableContent.add({...addNewTableContentData});
    tableContent.refresh();
    handleAddToDatabase();
  }

  handleNewTableContentOnSubmit() {
    tableContent.add(addNewTableContentData);
    tableContent.refresh();
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  handleAddToDatabase() async {
    final place = db.collection("Place");

    await place
        .where("workplace", isEqualTo: "Sumber Wringin")
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        db.collection("Place").doc().set({
          "place": [addNewTableContentData]
        });
      } else {
        for (var element in value.docs) {
          for (var place in element.data()["place"]) {
            if (place["ID"] == addNewTableContentData["ID"]) {
              Get.snackbar("Gagal Menyimpan", "Tempat Sudah Ada!");
            } else {
              db.collection("Place").doc(element.id).update({
                "place": FieldValue.arrayUnion([addNewTableContentData])
              });
              Get.snackbar(
                "Berhasil Menyimpan",
                "${addNewTableContentData["ID"]} Telah Ditambahkan",
              );
            }
          }
        }
        Get.toNamed("/registered-location");
      }
    });
  }
}
