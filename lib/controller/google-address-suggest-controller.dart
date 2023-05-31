import 'package:dio/dio.dart';
import 'package:get/get.dart';

class GoogleAddressSuggestController extends GetxController {
  //https://maps.googleapis.com/maps/api/geocode/json?address=84%20Ghanta%20Mandir&sensor=true&components=postal_code:243001|country:IN&key=AIzaSyCAX95S6o_c9fiX2gF3fYmZ-zjRWUN_nRo

  String mapKey = 'AIzaSyCAX95S6o_c9fiX2gF3fYmZ-zjRWUN_nRo';
  String host = 'https://maps.google.com/maps/api/geocode/json';
  Dio dio = Dio();
  RxList addressSuggestions = [].obs;

  Future<void> search(String changedText, String pincode) async {
    if (changedText.length > 2) {
      String host = 'https://maps.google.com/maps/api/geocode/json';
      var url =
          '$host?key=$mapKey&language=de&address=$changedText&sensor=true&components=postal_code:${pincode}';
      // url = url + '|country:IN';
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        addressSuggestions.value =
            (response.data['results'] as List).map((e) => e).toList();
      }
    }
  }
}
