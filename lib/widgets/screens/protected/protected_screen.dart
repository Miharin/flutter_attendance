import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/helper/protected/drawer.helper.dart';
import 'package:flutter_attendance/store/store/auth/auth_store.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/store/store/protected/attendance_store.dart';
import 'package:flutter_attendance/widgets/templates/etc/appbar.dart';
import 'package:get/get.dart';

class ProtectedScreen extends StatelessWidget {
  ProtectedScreen(
      {super.key, required this.child, required this.title, this.logOutButton});
  final String title;
  final Widget child;
  final bool? logOutButton;

  final CustomDrawerController _customDrawer =
      Get.put(CustomDrawerController());
  final AuthStore _isUserLogin = Get.put(AuthStore());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppbar(
        title: title,
        leading: IconButton(
          onPressed: () => _customDrawer.toggleDrawer(),
          icon: const Icon(Icons.menu),
        ),
        actions: [
          if (logOutButton != null && logOutButton!)
            IconButton(
                onPressed: () async {
                  await auth.signOut().then((value) {
                    cache.write("userIsLogin", false);
                    cache.remove("user");
                    _isUserLogin.userIsLogin.value = false;
                    Get.delete<AttendanceStore>();
                  });
                },
                icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: child,
    );
  }
}
