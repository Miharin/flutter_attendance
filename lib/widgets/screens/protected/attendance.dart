import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/controller/attendance_controller.dart';
import 'package:flutter_attendance/widgets/templates/buttons/filled_button.dart';
import 'package:flutter_attendance/widgets/templates/etc/card.dart';
import 'package:flutter_attendance/widgets/templates/buttons/choice_chip.dart';
import 'package:flutter_attendance/widgets/templates/inputs/text_form_field.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AttendanceScreen extends GetView<AttendanceController> {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: CustomFilledButton(
                      label: "Check In",
                      onPressed: !controller.store.isCheckIn.value &&
                              !controller.helper.isLoading.value
                          ? () => controller.helper.handleTimechange(
                                "Check In",
                                context,
                              )
                          : null,
                    ),
                  ),
                  Flexible(
                    child: CustomFilledButton(
                      label: "Check Out",
                      onPressed: !controller.store.isCheckOut.value &&
                              !controller.helper.isLoading.value
                          ? () => controller.helper.handleTimechange(
                                "Check Out",
                                context,
                              )
                          : null,
                    ),
                  ),
                ],
              )),
          Flexible(
            child: CustomFilledButton(
              label: "Lain-Nya",
              onPressed: !controller.store.isCheckIn.value &&
                      !controller.store.isCheckOut.value &&
                      !controller.helper.isLoading.value
                  ? () => showAlasan(context)
                  : null,
            ),
          ),
          AnimatedCrossFade(
              firstChild: mobileScreen(),
              secondChild: desktopScreen(),
              crossFadeState: MediaQuery.of(context).size.width > 800
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 500)),
        ],
      ),
    );
  }

  Widget mobileScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: CustomCardWithHeader(
            header: "Checkin",
            children: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Text(
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
          child: CustomCardWithHeader(
            header: "Checkout",
            children: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Text(
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
          child: CustomCardWithHeader(
            isGap: false,
            header: "Lain-Nya",
            children: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Text(
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
              header: "Checkin",
              children: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Text(
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
        ),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 150.0),
            child: CustomCardWithHeader(
              header: "Checkout",
              children: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Text(
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
                  child: Obx(
                    () => Text(
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
        ),
      ],
    );
  }

  Future<dynamic> showAlasan(BuildContext context) {
    return showModalBottomSheet(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height * 0.5,
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      context: context,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text("Alasan"),
                  Obx(() => Row(
                        children: List.generate(2, (int index) {
                          final List<String> title = ["Sakit", "Ijin"];
                          return CustomChoiceChip(
                            content: title[index],
                            selected: controller.store.index.value == index,
                            onSelected: (bool selected) =>
                                controller.helper.handleChange(
                              selected,
                              index,
                              controller.store.index.value,
                              controller.store.indexStatus.value,
                            ),
                          );
                        }),
                      )),
                  const Gap(10.0),
                  Obx(() => controller.store.index.value == 1
                      ? CustomTextFormField(
                          label: "Alasan",
                          verification: true,
                          maxlines: 3,
                          keyboardType: TextInputType.multiline,
                          onSave: (value) => controller.helper.handleAlasan(
                            value!,
                            controller.store.indexAlasan.value,
                          ),
                        )
                      : const Flexible(child: Text(""))),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomFilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: "Submit",
              ),
            ),
          ],
        );
      },
    );
  }
}
