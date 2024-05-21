import 'package:flutter_attendance/shared/routes/custom_routes.dart';
import 'package:flutter_attendance/widgets/screens/auth/auth_screen.dart';
import 'package:flutter_attendance/widgets/screens/auth/login_screen.dart';
import 'package:flutter_attendance/widgets/screens/protected/attendance.dart';
import 'package:flutter_attendance/widgets/screens/protected/dashboard_screen.dart';
import 'package:flutter_attendance/widgets/screens/protected/protected_screen.dart';
import 'package:get/get.dart';

class Routes {
  List<GetPage<dynamic>> routes = [
    GetPage(
      name: "/",
      page: () {
        return CustomRoutes(
          firstWidget: DashboardScreen(
              child: ProtectedScreen(
            title: "Absensi",
            child: const AttendanceScreen(),
          )),
          secondWidget: const AuthScreen(
            title: "Login",
            child: LoginScreen(),
          ),
        );
      },
    ),
  ];
}
