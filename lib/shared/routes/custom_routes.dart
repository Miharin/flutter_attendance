import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/store/controller/auth_controller.dart';
import 'package:get/get.dart';

class CustomRoutes extends StatelessWidget {
  CustomRoutes({
    super.key,
    required this.firstWidget,
    required this.secondWidget,
  });

  final Widget firstWidget;
  final Widget secondWidget;
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.store.checkAuthState(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            controller.store.checkIsUserLogin(snapshot.data!.uid);
          }
          // return Obx(() =>
          //     controller.store.userIsLogin.value ? firstWidget : secondWidget);
          return Obx(() => AnimatedCrossFade(
                layoutBuilder: (
                  topChild,
                  topChildKey,
                  bottomChild,
                  bottomChildKey,
                ) =>
                    topChild,
                firstChild: firstWidget,
                secondChild: secondWidget,
                crossFadeState: controller.store.userIsLogin.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(seconds: 1),
              ));
        }
      },
    );
  }
}
