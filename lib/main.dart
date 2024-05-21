import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/shared/colors/color_schemes.dart';
import 'package:flutter_attendance/shared/colors/custom_color.dart';
import 'package:flutter_attendance/shared/routes/routes.dart';
import 'package:flutter_attendance/store/controller/global_controller.dart';
import 'package:flutter_attendance/store/database_config/firebase_options.dart';
import 'package:flutter_attendance/store/extensions/scroll/custom_scroll_behavior.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting("in_in", null).then(
    (_) => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme? lightScheme;
      ColorScheme? darkScheme;

      if (lightDynamic != null && darkDynamic != null) {
        lightScheme = lightDynamic.harmonized();
        lightCustomColors = lightCustomColors.harmonized(lightScheme);

        darkScheme = darkDynamic.harmonized();
        darkCustomColors = darkCustomColors.harmonized(darkScheme);
      } else {
        lightScheme = lightColorScheme;
        darkScheme = darkColorScheme;
      }

      bool darkMode =
          MediaQuery.of(context).platformBrightness == Brightness.dark;

      return GetMaterialApp(
        title: 'Absensi Sumber Wringin',
        scrollBehavior: CustomScrollBehavior(),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: !darkMode ? lightScheme : darkScheme,
          extensions: [!darkMode ? lightCustomColors : darkCustomColors],
        ),
        getPages: Routes().routes,
        initialRoute: "/",
        initialBinding: GlobalController(),
      );
    });
  }
}