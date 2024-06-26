import 'package:flutter_attendance/shared/routes/custom_routes.dart';
import 'package:flutter_attendance/widgets/screens/auth/auth_screen.dart';
import 'package:flutter_attendance/widgets/screens/auth/login_screen.dart';
import 'package:flutter_attendance/widgets/screens/protected/attendance.dart';
import 'package:flutter_attendance/widgets/screens/protected/dashboard_screen.dart';
import 'package:flutter_attendance/widgets/screens/protected/history.dart';
import 'package:flutter_attendance/widgets/screens/protected/protected_screen.dart';
import 'package:flutter_attendance/widgets/screens/protected/register_place.dart';
import 'package:flutter_attendance/widgets/screens/protected/register_user.dart';
import 'package:flutter_attendance/widgets/screens/protected/table_place.dart';
import 'package:flutter_attendance/widgets/screens/protected/table_user.dart';
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
            logOutButton: true,
            child: AttendanceScreen(),
          )),
          secondWidget: AuthScreen(
            title: "Login",
            child: LoginScreen(),
          ),
        );
      },
    ),
    GetPage(
      name: "/Tabel_User",
      page: () {
        return CustomRoutes(
          firstWidget: DashboardScreen(
              child: ProtectedScreen(
            title: "Tabel User",
            child: TableUser(),
          )),
          secondWidget: AuthScreen(
            title: "Login",
            child: LoginScreen(),
          ),
        );
      },
    ),
    GetPage(
      name: "/Register_User",
      page: () {
        return CustomRoutes(
          firstWidget: DashboardScreen(
              child: ProtectedScreen(
            title: "Pendaftaran User",
            child: RegisterUser(),
          )),
          secondWidget: AuthScreen(
            title: "Login",
            child: LoginScreen(),
          ),
        );
      },
    ),
    GetPage(
      name: "/Tabel_Tempat",
      page: () {
        return CustomRoutes(
          firstWidget: DashboardScreen(
              child: ProtectedScreen(
            title: "Tabel Tempat",
            child: TablePlace(),
          )),
          secondWidget: AuthScreen(
            title: "Login",
            child: LoginScreen(),
          ),
        );
      },
    ),
    GetPage(
      name: "/Register_Place",
      page: () {
        return CustomRoutes(
          firstWidget: DashboardScreen(
              child: ProtectedScreen(
            title: "Pendaftaran Tempat",
            child: RegisterPlace(),
          )),
          secondWidget: AuthScreen(
            title: "Login",
            child: LoginScreen(),
          ),
        );
      },
    ),
    GetPage(
      name: "/History",
      page: () {
        return CustomRoutes(
          firstWidget: DashboardScreen(
              child: ProtectedScreen(
            title: "History",
            pdf: true,
            child: History(),
          )),
          secondWidget: AuthScreen(
            title: "Login",
            child: LoginScreen(),
          ),
        );
      },
    ),
  ];
}
