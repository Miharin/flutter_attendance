import 'dart:ui';

import 'package:flutter/material.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

extension UtilListExtension on List {
  groupBy(String key) {
    try {
      List<Map<String, dynamic>> result = [];
      List<String> keys = [];

      for (var f in this) {
        keys.add(f[key]);
      }

      for (var k in [...keys.toSet()]) {
        List data = [...where((e) => e[key] == k)];
        result.add({k: data});
      }

      return result;
    } catch (e, s) {
      debugPrint([e, s].toString());
      return this;
    }
  }
}
