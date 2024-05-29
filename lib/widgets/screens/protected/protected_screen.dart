import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/helper/protected/drawer.helper.dart';
import 'package:flutter_attendance/store/store/auth/auth_store.dart';
import 'package:flutter_attendance/shared/globals.dart';
import 'package:flutter_attendance/store/store/protected/history_store.dart';
import 'package:flutter_attendance/widgets/templates/etc/appbar.dart';
import 'package:get/get.dart';

class ProtectedScreen extends StatelessWidget {
  ProtectedScreen({
    super.key,
    required this.child,
    required this.title,
    this.logOutButton,
    this.pdf,
  });
  final String title;
  final Widget child;
  final bool? logOutButton;
  final bool? pdf;

  final CustomDrawerController _customDrawer =
      Get.put(CustomDrawerController());
  final AuthStore _isUserLogin = Get.put(AuthStore());
  final HistoryStore _store = Get.put(HistoryStore());

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
                  });
                },
                icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: child,
      floatingActionButton: pdf != null && pdf!
          ? FloatingActionButton(
              onPressed: () => _store.makePDF(),
              child: const Icon(Icons.picture_as_pdf_rounded),
            )
          : null,
    );
  }
}
