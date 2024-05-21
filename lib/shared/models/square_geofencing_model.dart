import 'package:geolocator/geolocator.dart';

class SquareGeoFencing {
  const SquareGeoFencing({
    required this.id,
    required this.latitudeStart,
    required this.latitudeEnd,
    required this.longitudeStart,
    required this.longitudeEnd,
  });

  final String id;
  final double latitudeStart;
  final double latitudeEnd;
  final double longitudeStart;
  final double longitudeEnd;

  factory SquareGeoFencing.fromJson(Map<String, dynamic> geoFencingJSON) =>
      SquareGeoFencing(
        id: geoFencingJSON["ID"],
        latitudeStart: double.parse(geoFencingJSON["LatitudeStart"]),
        latitudeEnd: double.parse(geoFencingJSON["LatitudeEnd"]),
        longitudeStart: double.parse(geoFencingJSON["LongitudeStart"]),
        longitudeEnd: double.parse(geoFencingJSON["LongitudeEnd"]),
      );
}

class GeoFencing {
  const GeoFencing({this.listSquareGeoFencing});
  const GeoFencing.square({required this.listSquareGeoFencing});
  final List<SquareGeoFencing>? listSquareGeoFencing;

  Future<bool> isInsideSquareGeoFencing() async {
    Position position = await Geolocator.getCurrentPosition();
    for (var geoFencing in listSquareGeoFencing!) {
      if (position.latitude
              .isMinBetween(geoFencing.latitudeStart, geoFencing.latitudeEnd) &&
          position.longitude
              .isBetween(geoFencing.longitudeStart, geoFencing.longitudeEnd)) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<List> listGeoFencing() async {
    List listGeo = [];
    for (var geoFencing in listSquareGeoFencing!) {
      Map geoFence = {
        "workplaceId": geoFencing.id,
        "latitudeStart": geoFencing.latitudeStart,
        "latitudeEnd": geoFencing.latitudeEnd,
        "longitudeStart": geoFencing.longitudeStart,
        "longitudeEnd": geoFencing.longitudeEnd,
      };
      listGeo.add(geoFence);
    }
    return listGeo;
  }
}

extension Range on double {
  bool isMinBetween(double from, double to) {
    return from >= this && this >= to;
  }

  bool isBetween(double from, double to) {
    return from <= this && this <= to;
  }
}
