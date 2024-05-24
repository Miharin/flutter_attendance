import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/store/helper/protected/drawer.helper.dart';
import 'package:flutter_attendance/widgets/templates/etc/divider.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class DashboardScreen extends GetView<CustomDrawerController> {
  const DashboardScreen({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomDrawerController>(builder: (controller) {
      return ZoomDrawer(
        controller: controller.zoomDrawerController,
        borderRadius: 24.0,
        showShadow: true,
        angle: -12.0,
        style: DrawerStyle.defaultStyle,
        drawerShadowsBackgroundColor: Colors.grey[300]!,
        slideWidth: 300,
        menuScreen: DrawerMenu(),
        mainScreen: child,
      );
    });
  }
}

class DrawerMenu extends StatelessWidget {
  DrawerMenu({
    super.key,
  });

  final String chacheRole = cache.read("user")["role"];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 0.2,
        ),
      ),
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.grey[300]!,
                    ),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Menu",
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_rounded),
              title: const Text("Absensi"),
              onTap: () {
                Get.toNamed("/");
              },
            ),
            const CustomDivider(
              space: 15.0,
            ),
            if (cache.read("user")["role"] == "admin")
              ExpansionTile(
                leading: const Icon(Icons.people_alt_rounded),
                title: const Text("User"),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Daftar User"),
                    onTap: () {
                      Get.toNamed("/Tabel_User");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: const Text("Pendaftaran User"),
                    onTap: () {
                      Get.toNamed("/Register_User");
                    },
                  ),
                ],
              ),
            if (cache.read("user")["role"] == "admin")
              ExpansionTile(
                leading: const Icon(Icons.location_pin),
                title: const Text('Lokasi'),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                children: [
                  ListTile(
                    leading: const Icon(Icons.location_city_rounded),
                    title: const Text("Lokasi Terdaftar"),
                    onTap: () {
                      Get.toNamed("/Tabel_Tempat");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.app_registration_rounded),
                    title: const Text("Pendaftaran Tempat"),
                    onTap: () {
                      Get.toNamed("/Register_Place");
                    },
                  ),
                ],
              ),
            if (cache.read("user")["role"] == "admin")
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("History"),
                onTap: () {
                  Get.toNamed("/History");
                },
              ),
          ],
        ),
      ),
    );
  }
}
