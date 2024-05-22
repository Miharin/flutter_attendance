import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/controller/attendance_controller.dart';
import 'package:flutter_attendance/widgets/templates/buttons/filled_button.dart';
import 'package:flutter_attendance/widgets/templates/etc/card.dart';
import 'package:get/get.dart';

class AttendanceScreen extends GetView<AttendanceController> {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    isEnableCheckButton() {
      if (controller.store.isAbsent.value || controller.store.isCheckIn.value) {
        return false;
      } else if (controller.store.isAbsent.value ||
          controller.store.isCheckOut.value) {
        return false;
      } else if (controller.store.isCheckIn.value ||
          controller.store.isCheckOut.value ||
          controller.store.isAbsent.value) {
        return false;
      } else if (controller.helper.isLoading.value) {
        return false;
      } else {
        return true;
      }
    }

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
                      onPressed: isEnableCheckButton()
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
                      onPressed: isEnableCheckButton()
                          ? () => controller.helper.handleTimechange(
                                "Check Out",
                                context,
                              )
                          : null,
                    ),
                  ),
                ],
              )),
          Obx(() => Flexible(
                child: CustomFilledButton(
                  label: "Lain-Nya",
                  onPressed: isEnableCheckButton()
                      ? () => controller.helper.handleTimechange(
                            "Lain-Nya",
                            context,
                          )
                      : null,
                ),
              )),
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
}
