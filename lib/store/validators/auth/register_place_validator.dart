import 'package:get/get.dart';

class RegisterPlaceValidator extends GetxController {
  final RxMap<String, bool> registerPlaceVerfication = {
    "LongitudeStart": false,
    "LongitudeEnd": false,
    "LatitudeStart": false,
    "LatitudeEnd": false,
  }.obs;
}
