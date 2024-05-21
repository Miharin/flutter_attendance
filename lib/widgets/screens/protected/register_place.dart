import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_attendance/store/helper/protected/table_place_helper.dart';
import 'package:flutter_attendance/widgets/templates/buttons/filled_button.dart';
import 'package:flutter_attendance/widgets/templates/inputs/text_form_field.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RegisterPlace extends StatelessWidget {
  RegisterPlace({super.key});

  final tablePlaceHelper = Get.put(TablePlaceHelper());

  @override
  Widget build(BuildContext context) {
    var regExpLat = RegExp(
      '^[-+]?((90(\\.0)?)|([1-8]?\\d{0,1}(\\.\\d{0,7})?)|(-90(\\.0)?))',
    );
    var regExpLong = RegExp(
        '^[-+]?((180(\\.0)?)|([1-8]?\\d{0,2}(\\.\\d{0,7})?)|(-180(\\.0)?))');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(
            label: "ID",
            verification: true,
            onSave: (value) =>
                tablePlaceHelper.handleAddNewtableContent("ID", value),
          ),
          latitudeTextField(regExpLat),
          longitudeTextField(regExpLong),
          Flexible(
            child: CustomFilledButton(
              label: "Daftar",
              onPressed: () {
                tablePlaceHelper.handleSubmitAddDataContent();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget longitudeTextField(RegExp regExpLong) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextFormField(
          label: "LongitudeStart",
          verification: true,
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
            decimal: true,
          ),
          inputFormatter: [FilteringTextInputFormatter.allow(regExpLong)],
          onSave: (value) => tablePlaceHelper.handleAddNewtableContent(
              "LongitudeStart", value),
        ),
        const Gap(5.0),
        CustomTextFormField(
          label: "LongitudeEnd",
          verification: true,
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
            decimal: true,
          ),
          inputFormatter: [
            FilteringTextInputFormatter.allow(regExpLong),
          ],
          onSave: (value) =>
              tablePlaceHelper.handleAddNewtableContent("LongitudeEnd", value),
        ),
      ],
    );
  }

  Widget latitudeTextField(RegExp regExpLat) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextFormField(
          label: "LatitudeStart",
          verification: true,
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
            decimal: true,
          ),
          inputFormatter: [
            FilteringTextInputFormatter.allow(
              regExpLat,
            )
          ],
          onSave: (value) =>
              tablePlaceHelper.handleAddNewtableContent("LatitudeStart", value),
        ),
        const Gap(5.0),
        CustomTextFormField(
          label: "LatitudeEnd",
          verification: true,
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
            decimal: true,
          ),
          inputFormatter: [
            FilteringTextInputFormatter.allow(
              regExpLat,
            )
          ],
          onSave: (value) =>
              tablePlaceHelper.handleAddNewtableContent("LatitudeEnd", value),
        ),
      ],
    );
  }
}
