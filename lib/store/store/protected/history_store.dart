import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/shared/models/user_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HistoryStore extends GetxController {
  // Get User Cache Role and Name
  final String cacheRole =
      cache.read("user") != null ? cache.read("user")["role"] : "";
  final cacheUsername =
      cache.read("user") != null ? cache.read("user")["email"] : "";

  // Data History
  final RxList userDataCheck = [].obs;
  final RxList userDataBackup = [].obs;

  final RxString tahun = "".obs;
  final RxString bulan = "".obs;
  final RxString name = "".obs;
  final RxString type = "".obs;

  static const _darkColor = PdfColors.blueGrey800;

  @override
  void onInit() {
    super.onInit();
    // Fetch This While Building Widgets
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (cache.read("userIsLogin")) {
        _getData();
      }
    });
  }

  void getFilteredData() async {
    userDataCheck.value = [];
    final month = List.generate(
      12,
      (index) =>
          DateFormat("MMMM", "id_ID").format(DateTime(0, index + 1)).toString(),
    );
    userDataCheck.value = userDataBackup
        .where((user) =>
            (name.value != ""
                ? name.value == "All"
                    ? user["name"] != ""
                    : user["name"] == name.value
                : user["name"] != "") &&
            (bulan.value != ""
                ? (month.indexWhere((m) => m == bulan.value) + 1).toString() ==
                    int.parse(user["dateTime"].split("-")[1]).toString()
                : user["dateTime"] != "") &&
            (tahun.value != ""
                ? tahun.value == user["dateTime"].split("-")[0]
                : user["dateTime"] != "") &&
            (type.value != ""
                ? type.value == "All"
                    ? user["type"] != ""
                    : type.value == user["type"]
                : user["type"] != ""))
        .toList();
  }

  Future makePDF() async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          orientation: pw.PageOrientation.landscape,
          build: (pw.Context context) => [_contentHeader(context)],
        ),
      );

      final month = List.generate(
        12,
        (index) => DateFormat("MMMM", "id_ID")
            .format(DateTime(0, index + 1))
            .toString(),
      );
      final outputYear =
          tahun.value != "" ? tahun.value : DateTime.now().year.toString();
      final outputMonth =
          bulan.value != "" ? bulan.value : month[DateTime.now().month - 1];

      try {
        final outputFile = await FilePicker.platform.saveFile(
          dialogTitle: "Save Your File to Desired Location",
          fileName: "History Absensi Pada $outputMonth $outputYear",
        );
        if (outputFile != null) {
          final file = File(
              outputFile.contains(".pdf") ? outputFile : "$outputFile.pdf");
          await file.writeAsBytes(await pdf.save());
          Get.snackbar(
            "Simpan Berhasil",
            "PDF Telah Disimpan di ${outputFile.contains(".pdf") ? outputFile : "$outputFile.pdf"}",
            duration: const Duration(seconds: 7),
          );
        }
      } catch (e) {
        if (kIsWeb) {
          await FileSaver.instance.saveFile(
            name: "History Absensi Pada $outputMonth $outputYear",
            bytes: await pdf.save(),
            ext: "pdf",
            mimeType: MimeType.pdf,
          );
          Get.snackbar(
            "Simpan Berhasil",
            "PDF Telah Di Download",
            duration: const Duration(seconds: 7),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
    if (cacheRole == "Admin") {
      query = timeCollection
          .where(
            Filter.and(
              Filter("year", isEqualTo: DateTime.now().year.toString()),
              Filter("month", isEqualTo: DateTime.now().month.toString()),
            ),
          )
          .get();
    }

    // Else Get Data Where Name == Name In Login and this Year
    else {
      query = timeCollection
          .where(
            Filter.and(
              Filter("email", isEqualTo: cacheUsername),
              Filter("year", isEqualTo: year.toString()),
              Filter("month", isEqualTo: date.month.toString()),
            ),
          )
          .get();
    }
    if (cache.read("userIsLogin") != null &&
        cache.read("userIsLogin") == true) {
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
                final userHistory = UserHistoryModel.fromJson({
                  "datetime": timestampData["datetime"],
                  "latitude": timestampData["latitude"],
                  "longitude": timestampData["longitude"],
                  "status": timestampData["status"],
                  "statusOutside": "Sakit",
                  "type": timestampData["type"],
                  "workplace_id": timestampData["workplace_id"],
                  "alasan": "Sakit",
                }, timestamp["name"])
                    .toMap();
                userDataCheck.add(userHistory);
                userDataBackup.add(userHistory);
              } else {
                final userHistory = UserHistoryModel.fromJson(
                  timestampData,
                  timestamp["name"],
                ).toMap();
                userDataCheck.add(userHistory);
                userDataBackup.add(userHistory);
              }
            }
          }
        }
      });
    }
  }

  pw.Widget _contentHeader(pw.Context context) {
    const tableHeaders = [
      "Name",
      "Date Time",
      "Status",
      "Penyebab",
      "Type",
      "Tempat",
      "Alasan",
    ];
    const headerWidth = [
      100.0,
      150.0,
      100.0,
      100.0,
      100.0,
      100.0,
      300.0,
    ];
    const indexHeaders = [
      "name",
      "dateTime",
      "status",
      "statusOutside",
      "type",
      "workplaceID",
      "alasan",
    ];

    return pw.TableHelper.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.purple200,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.centerLeft,
        5: pw.Alignment.centerLeft,
        6: pw.Alignment.centerLeft,
      },
      headerStyle: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            width: .5,
          ),
        ),
      ),
      headers: List.generate(
        tableHeaders.length,
        (col) => pw.SizedBox(
          width: headerWidth[col],
          child: pw.Text(
            tableHeaders[col],
          ),
        ),
      ),
      data: List<List>.generate(
        userDataCheck.length,
        (row) => List.generate(
          tableHeaders.length,
          (col) {
            if (indexHeaders[col] == "status") {
              if (userDataCheck[row][indexHeaders[col]] ==
                  "Outside Workplace") {
                return pw.SizedBox(
                  width: headerWidth[col],
                  child: pw.Text(
                    "Diluar",
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                );
              } else if (userDataCheck[row][indexHeaders[col]] ==
                  "Inside Workplace") {
                return pw.SizedBox(
                  width: headerWidth[col],
                  child: pw.Text(
                    "Masuk",
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                );
              } else {
                return pw.SizedBox(
                  width: headerWidth[col],
                  child: pw.Text(
                    userDataCheck[row][indexHeaders[col]],
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                );
              }
            } else {
              return userDataCheck[row][indexHeaders[col]] != ""
                  ? pw.SizedBox(
                      width: headerWidth[col],
                      child: pw.Text(
                        indexHeaders[col] == "name"
                            ? userDataCheck[row][indexHeaders[col]]
                                .split(" ")
                                .map((e) => e.toString().capitalize!)
                                .join(" ")
                                .toString()
                            : userDataCheck[row][indexHeaders[col]],
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.normal,
                        ),
                        textAlign: indexHeaders[col] == "statusOutside"
                            ? pw.TextAlign.center
                            : pw.TextAlign.left,
                      ),
                    )
                  : pw.SizedBox(
                      width: headerWidth[col],
                      child: pw.Text(
                        "-",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.normal,
                        ),
                        textAlign: indexHeaders[col] == "statusOutside"
                            ? pw.TextAlign.center
                            : pw.TextAlign.left,
                      ),
                    );
            }
          },
        ),
      ),
    );
  }
}
