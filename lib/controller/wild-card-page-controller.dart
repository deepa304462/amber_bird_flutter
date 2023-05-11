import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class WildCardPageController extends GetxController {
  Rx<Uri> uri = Uri().obs;

  WildCardPageController(Uri givenUri) {
    uri.value = givenUri;
    syncPath(givenUri);
  }

  Future<void> syncPath(Uri givenUri) async {
    print(givenUri);
    print("givenUri");
    if (givenUri.path.contains('refer')) {
      String referById = givenUri.path.split('/')[2];
      String existing = '';
      try {
        existing = await SharedData.read('referBy');
      } catch (e) {}
      if (existing.isNotEmpty) {
      } else {
        CodeHelp.toast(
            'Received reference, Thank you. Offer will apply while checkout.');
        SharedData.save(referById, 'referBy');
      }
      Modular.to.navigate("/home/main");
    } else if (givenUri.path.contains('app')) {
      String shortcodeId = givenUri.path.split('/')[2];
      var payload = {
        "shortUrl": shortcodeId,
      };
      print(payload);
      var resp =
          await ClientService.post(path: 'marketingData', payload: payload);
      if (resp.statusCode == 200 && resp.data['_id'] != null && resp.data['_id'] != '') {
        Modular.to.pushNamed('/widget/product/${resp.data['_id']}'); 
      } else { 
        Modular.to.navigate("/home/main");
      }
    }
  }
}
